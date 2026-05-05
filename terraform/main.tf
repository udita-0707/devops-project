# ============================================================================
# ShopSmart Infrastructure as Code
# AWS Infrastructure using Terraform
# ============================================================================

# Terraform configuration and required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # # Remote backend configuration for S3
  backend "s3" {
    bucket         = "shopsmart-terraform-state-339712978141"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "shopsmart-terraform-locks"
    encrypt        = true
  }
}

# AWS provider configuration
provider "aws" {
  region = "us-east-1"
}

# Data source to retrieve current AWS account ID
data "aws_caller_identity" "current" {}

# ============================================================================
# Terraform State Management
# ============================================================================

# S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "shopsmart-terraform-state-${data.aws_caller_identity.current.account_id}"

  # Prevent accidental deletion of this bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning for state bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for state bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access to state bucket for security
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "shopsmart-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Prevent accidental deletion of this table
  lifecycle {
    prevent_destroy = true
  }
}

# ============================================================================
# S3 Storage Resources
# ============================================================================

# S3 bucket for storing user uploads
resource "aws_s3_bucket" "uploads_bucket" {
  bucket = "shopsmart-uploads-udita"
}

# S3 bucket for storing application logs
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "shopsmart-logs-udita"
}

# Enable versioning for uploads bucket
resource "aws_s3_bucket_versioning" "uploads_versioning" {
  bucket = aws_s3_bucket.uploads_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable versioning for logs bucket
resource "aws_s3_bucket_versioning" "logs_versioning" {
  bucket = aws_s3_bucket.logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for uploads bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "uploads_encryption" {
  bucket = aws_s3_bucket.uploads_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable server-side encryption for logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "logs_encryption" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to uploads bucket for security
resource "aws_s3_bucket_public_access_block" "uploads_public_access" {
  bucket = aws_s3_bucket.uploads_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access to logs bucket for security
resource "aws_s3_bucket_public_access_block" "logs_public_access" {
  bucket = aws_s3_bucket.logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================================================
# ECR (Elastic Container Registry) Resources
# ============================================================================

# ECR repository for backend Docker images
resource "aws_ecr_repository" "backend_repo" {
  name = "devops-backend"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECR repository for frontend Docker images
resource "aws_ecr_repository" "frontend_repo" {
  name = "devops-frontend"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ============================================================================
# ECS (Elastic Container Service) Resources
# ============================================================================

# ECS cluster for hosting containerized applications
resource "aws_ecs_cluster" "main" {
  name = "devops-cluster"
}

# CloudWatch log group for backend ECS service logs
resource "aws_cloudwatch_log_group" "backend_logs" {
  name = "/ecs/backend"

  retention_in_days = 7
}

# CloudWatch log group for frontend ECS service logs
resource "aws_cloudwatch_log_group" "frontend_logs" {
  name = "/ecs/frontend"

  retention_in_days = 7
}

# ECS task definition for backend service
# Specifies Docker container configuration, CPU, memory, and logging
resource "aws_ecs_task_definition" "backend" {
  family                   = "devops-backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  task_role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = "${aws_ecr_repository.backend_repo.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend_logs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])
}

# ECS task definition for frontend service
# Specifies Docker container configuration, CPU, memory, and logging
resource "aws_ecs_task_definition" "frontend" {
  family                   = "devops-frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  task_role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

  container_definitions = jsonencode([
    {
      name      = "frontend-container"
      image     = "${aws_ecr_repository.frontend_repo.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.frontend_logs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])
}

# ============================================================================
# Security Group
# ============================================================================

# Security group for ECS Fargate services
# Allows inbound traffic on ports 80 (HTTP) and 3000 (API)
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-fargate-sg"
  description = "Security group for ShopSmart ECS services"
  vpc_id      = "vpc-04f7b24ca92ccdd06"

  # Allow inbound HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound API traffic
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ============================================================================
# ECS Services
# ============================================================================

# Backend ECS service
# Runs the backend task definition in the ECS cluster
resource "aws_ecs_service" "backend_service" {
  name                 = "backend-service"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.backend.arn
  launch_type          = "FARGATE"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets = [
      "subnet-0d62c3e9d8714ea7c",
      "subnet-0ecbebbd867ac4288"
    ]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

# Frontend ECS service
# Runs the frontend task definition in the ECS cluster
resource "aws_ecs_service" "frontend_service" {
  name                 = "frontend-service"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.frontend.arn
  launch_type          = "FARGATE"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets = [
      "subnet-0d62c3e9d8714ea7c",
      "subnet-0ecbebbd867ac4288"
    ]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}