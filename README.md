# ShopSmart - E-Commerce DevOps Project

A full-stack e-commerce platform demonstrating modern DevOps practices, CI/CD automation, and infrastructure-as-code (IaC) deployment to AWS.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Infrastructure](#infrastructure)
- [Design Decisions](#design-decisions)
- [Challenges & Solutions](#challenges--solutions)

## 🎯 Project Overview

ShopSmart is a modern e-commerce platform showcasing industry best practices for:
- Full-stack web application development
- Containerization with Docker
- Cloud infrastructure management with AWS and Terraform
- CI/CD automation with GitHub Actions
- Comprehensive testing strategies (unit, integration, E2E)
- Security and code quality practices

## 🏗️ Architecture

ShopSmart uses a decoupled, microservices-ready architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                        Frontend (React)                      │
│                    Deployed on ECS Fargate                   │
│                     (Port 80 - HTTP)                         │
└──────────────────────────────────────┬──────────────────────┘
                                       │
                           (REST API Calls)
                                       │
┌──────────────────────────────────────▼──────────────────────┐
│                     Backend (Node.js/Express)                │
│                    Deployed on ECS Fargate                   │
│                     (Port 3000 - API)                        │
└──────────────────────────────────────┬──────────────────────┘
                                       │
         ┌─────────────────────────────┼─────────────────────────┐
         │                             │                         │
    ┌────▼──────┐          ┌───────────▼────────┐      ┌─────────▼──────┐
    │ S3 Storage│          │ CloudWatch Logs    │      │ RDS (Optional) │
    │ (Uploads) │          │ (Centralized Logs) │      │ (Future)       │
    └───────────┘          └────────────────────┘      └────────────────┘
```

**Key Components:**
- **Frontend**: React.js application using Vite, featuring responsive UI with React Hooks
- **Backend**: Node.js/Express.js RESTful API handling business logic and product serving
- **Database**: S3 for file storage, CloudWatch for logging
- **Container Registry**: AWS ECR for storing Docker images
- **Orchestration**: AWS ECS Fargate for serverless container management

## 🛠️ Tech Stack

### Frontend
- **Framework**: React 18
- **Build Tool**: Vite
- **State Management**: React Hooks
- **Testing**: Vitest (unit), Cypress & Playwright (E2E)
- **Code Quality**: ESLint with React plugins
- **Styling**: CSS with modern variables and dark mode support

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Testing**: Jest with Supertest
- **Code Quality**: ESLint
- **Logging**: CloudWatch
- **Security**: CORS, environment variable management

### DevOps & Infrastructure
- **Containerization**: Docker
- **Container Registry**: AWS ECR
- **Orchestration**: AWS ECS Fargate
- **Infrastructure as Code**: Terraform
- **CI/CD**: GitHub Actions
- **Cloud Provider**: AWS (us-east-1 region)
- **Dependency Management**: Dependabot

## 📁 Project Structure

```
devops-project/
├── frontend/                    # React.js application
│   ├── src/
│   │   ├── components/         # Reusable UI components
│   │   ├── App.jsx
│   │   ├── main.jsx
│   │   └── utils.js            # Helper functions
│   ├── cypress/                # E2E tests
│   │   └── e2e/
│   ├── e2e/                    # Playwright tests
│   ├── package.json
│   ├── vite.config.js
│   ├── eslint.config.js
│   └── playwright.config.js
│
├── backend/                     # Express.js API
│   ├── src/
│   │   ├── index.js            # Server entry point
│   │   ├── app.js              # Express app config
│   │   └── routes/             # API endpoints
│   ├── tests/
│   │   └── app.test.js         # Unit & integration tests
│   ├── package.json
│   ├── jest.config.js
│   └── eslint.config.cjs
│
├── terraform/                   # Infrastructure as Code
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   └── .terraform.lock.hcl     # Provider lock file
│
├── .github/
│   └── workflows/
│       ├── ci.yml              # Continuous Integration pipeline
│       └── deploy.yml          # Continuous Deployment pipeline
│
├── Dockerfile                   # Container image definition
├── deploy.sh                    # Deployment helper script
└── README.md                    # This file
```

## 🚀 Getting Started

### Prerequisites

- Node.js 18+
- Docker & Docker Compose
- Terraform 1.0+
- AWS CLI configured with credentials
- Git

### Local Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/udita-0707/devops-project.git
   cd devops-project
   ```

2. **Install dependencies**
   ```bash
   # Backend
   cd backend
   npm install

   # Frontend
   cd ../frontend
   npm install
   ```

3. **Set up environment variables**
   ```bash
   # Backend
   cd backend
   cat > .env << EOF
   PORT=3000
   NODE_ENV=development
   EOF

   # Frontend - typically no env needed for local dev
   ```

4. **Start development servers**
   ```bash
   # Terminal 1: Backend
   cd backend
   npm run dev

   # Terminal 2: Frontend
   cd frontend
   npm run dev
   ```

   The application will be available at:
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:3000

## 🧪 Testing

### Backend Testing

```bash
cd backend

# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage
```

### Frontend Testing

```bash
cd frontend

# Run unit tests with Vitest
npm test

# Run E2E tests with Cypress
npm run test:e2e

# Run E2E tests with Playwright
npx playwright test
```

### Code Quality

```bash
cd frontend
npm run lint

cd ../backend
npm run lint
```

## 📦 Deployment

### Docker Build

```bash
# Build backend image
docker build -t devops-backend:latest -f Dockerfile .

# Build frontend image
docker build -t devops-frontend:latest -f Dockerfile .

# Push to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

docker tag devops-backend:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/devops-backend:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/devops-backend:latest
```

### CI/CD Pipeline

The project uses **GitHub Actions** for automated CI/CD:

#### Continuous Integration (`ci.yml`)
- Runs on every `push` and `pull_request` to `main`
- Steps:
  1. Install dependencies for both frontend and backend
  2. Run linting with ESLint
  3. Execute unit tests (Vitest for frontend, Jest for backend)
  4. Run E2E tests (Cypress and Playwright)
  5. Report results and block merge if tests fail

#### Continuous Deployment (`deploy.yml`)
- Triggers on successful CI and merge to `main`
- Steps:
  1. Build Docker images
  2. Push images to AWS ECR
  3. SSH into EC2 instance
  4. Pull latest images and restart services using PM2
  5. Verify deployment health

### Manual Deployment

```bash
./deploy.sh
```

## 🏗️ Infrastructure

### Terraform Deployment

```bash
cd terraform

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure changes
terraform apply

# Destroy infrastructure (caution!)
terraform destroy
```

### AWS Resources Created

- **S3 Buckets**: For uploads and application logs with versioning and encryption
- **ECR Repositories**: For backend and frontend Docker images
- **ECS Cluster**: Fargate-based container orchestration
- **ECS Task Definitions**: Configuration for backend and frontend tasks
- **ECS Services**: Manages running tasks for backend and frontend
- **CloudWatch Logs**: Centralized logging for containers
- **Security Groups**: Network access rules
- **IAM Roles**: Execution roles for ECS tasks

## 🎨 Design Decisions

### 1. **Modularity**
   - Backend and frontend are separate applications in distinct folders
   - Allows independent scaling, deployment, and team management
   - Clear separation of concerns

### 2. **Idempotency**
   - All deployment scripts and CI workflows are idempotent
   - Commands like `mkdir -p` and conditional restarts ensure safe re-deployments
   - No manual cleanup needed between deployments

### 3. **Containerization**
   - Docker for consistent development and production environments
   - Multi-stage builds for optimized image sizes
   - Layered caching for faster builds

### 4. **Infrastructure as Code**
   - Terraform for reproducible AWS infrastructure
   - Version-controlled configuration enables easy rollback
   - Environment-agnostic resource definitions

### 5. **Premium UI Design**
   - Dark-mode first CSS with CSS variables
   - Modern typography and responsive design
   - Minimal external dependencies for lightweight build

### 6. **Security**
   - Environment variable management for sensitive data
   - Public access blocks on S3 buckets
   - CORS properly configured for API communication
   - ECR image scanning enabled

## 🔧 Challenges & Solutions

### Challenge 1: Test Environment Orchestration
**Problem**: Coordinating Vitest, Jest, and Cypress in a single CI pipeline without conflicts

**Solution**:
- Separate test jobs for frontend and backend
- Wait for services to be ready before E2E tests
- Use containerized task executions to isolate environments

### Challenge 2: Secure SSH Deployment
**Problem**: Managing credentials and ensuring no key leaks during automated deployment

**Solution**:
- Store sensitive data in GitHub Secrets
- Use dedicated deploy user with limited permissions
- Implement SSH key rotation and audit logging

### Challenge 3: Zero-Downtime Deployment
**Problem**: Updating running services without service interruption

**Solution**:
- Blue-green deployment strategy with PM2
- Health checks before marking service as healthy
- Graceful shutdown handling

### Challenge 4: Database State Management
**Problem**: Keeping development and production environments in sync

**Solution**:
- Database migrations as code
- Seed scripts for reproducible states
- Environment-specific configuration

## 📈 Monitoring & Logs

All container logs are centralized in CloudWatch:
- **Backend Logs**: `/ecs/backend`
- **Frontend Logs**: `/ecs/frontend`

Access logs:
```bash
aws logs tail /ecs/backend --follow
aws logs tail /ecs/frontend --follow
```

## 🤝 Contributing

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit your changes (`git commit -m 'Add amazing feature'`)
3. Push to the branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request
5. Wait for CI checks to pass
6. Request review from team members

## 📝 License

This project is licensed under the ISC License - see the package.json files for details.

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

**Last Updated**: April 28, 2026
**Status**: Active Development
