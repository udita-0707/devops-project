# ShopSmart (DevOps Project)

## Architecture
ShopSmart is an e-commerce platform built with a modern, decoupled architecture:
- **Frontend**: A React.js application using Vite, featuring a responsive, clean, and premium UI. It manages state using React Hooks and fetches data seamlessly from the backend.
- **Backend**: A Node.js/Express.js RESTful API handling business logic and serving products. The backend manages server health and cross-origin resource sharing (CORS) securely.

## Workflow
We follow a strict CI/CD workflow driven by GitHub Actions:
1. **Continuous Integration (CI)**: On every `push` and `pull_request` to the `main` branch, our pipeline (`ci.yml`) automatically installs dependencies, runs Vitest and Jest unit tests, executes ESLint for code quality, and performs E2E checks with Cypress/Playwright.
2. **Dependabot**: Automated weekly checks keep all NPM packages and GitHub Actions up to date securely.
3. **Continuous Deployment (CD)**: The `deploy.yml` workflow securely connects via SSH into our AWS EC2 instance and executes an idempotent set of deployment commands to ensure no downtime.

## Design Decisions
- **Modularity**: We separated the backend and frontend into distinct folders (`/frontend`, `/backend`) for clear boundaries allowing for independent scaling and management.
- **Idempotency**: All deployment scripts and CI workflows are highly idempotent. Commands like `mkdir -p` and conditional fallbacks (`pm2 restart || pm2 start`) ensure deployments cannot fail due to a dirty active repository state.
- **Premium UI Aesthetics**: We implemented a dark-mode first design natively using CSS variables and modern typography, removing the need for heavy UI frameworks while maintaining a visually stunning application.
- **Automated Validation**: We strictly integrated pre-deployment code quality checks leveraging ESLint so bad code is caught instantly in pull requests rather than runtime.

## Challenges
- Maintaining clean test environments across both the frontend and backend simultaneously required orchestrating Vitest, Jest, and Cypress in isolation. We overcame this by setting up containerized task executions within our GitHub Actions pipeline, specifically by waiting for both node modules to start (`&` background tasks plus `sleep`) before hitting Cypress E2E.
- Implementing an automated SSH deployment to EC2 required careful management of GitHub Secrets (`EC2_HOST`, `EC2_USER`, `EC2_SSH_KEY`), making sure no keys were leaked, and crafting deployment command sequences that wouldn't wipe out running pm2 processes or crash if the directory already existed.
