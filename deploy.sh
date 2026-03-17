#!/bin/bash

APP_DIR="Devops-Project"

mkdir -p $APP_DIR
cd $APP_DIR

git pull origin main || git clone <your-repo-url> .

cd backend
npm install

pm2 restart app || pm2 start index.js --name app