# Thesis Reference Project - Three Tier Web Application, Terraform, and Chaos Engineering Implementation

A Next.JS and FastAPI reference project for undergrad thesis that focuses on CI/CD of infrastructure and Chaos Engineering implementation.

## Getting Started

### Prerequisites

- [NodeJS](https://nodejs.org/en/download/)
- [Python](https://www.python.org/downloads/)
- [Terraform](https://www.terraform.io/downloads.html)

### Installation

1. Clone the repo
   ```sh
   git clone
   ```
2. Install NPM packages
   ```sh
   cd frontend
   npm install
   ```
3. Install Python packages
   ```sh
   cd backend
   pip install -r requirements.txt
   ```

## Usage

### Frontend

Frontend environment variables are stored in `.env.local` file in frontend directory. The file should contain the following variables:

- NEXTAUTH_PUBLIC_BACKEND_URL (point to backend server)
- NEXTAUTH_SECRET

1. Run the frontend
   ```sh
   cd frontend
   npm run dev
   ```
2. Open the browser and go to `http://localhost:3000`

### Backend

For first time use, uncomment the following lines in `main.py` to create database tables.

```python
    models.Base.metadata.create_all(bind=engine)
```

Backend environment variables are stored in `.env` file in backend directory. The file should contain the following variables:

- DB_DRIVER (mysql)
- DB_HOST (point to database server)
- DB_PORT
- DB_NAME
- DB_USER
- DB_PASS
- SSL_CA (point to SSL CA file)
- ALGORITHM (HS256)
- ACCESS_TOKEN_EXPIRE_MINUTES (150)

1. Run the backend
   ```sh
   cd backend
   uvicorn main:app --reload --port 8080
   ```
2. Open the browser and go to `http://localhost:8080`

### Cypress

Cypress can be run against development server or production server. To run against development server.

Skip step 1 and 2 if you want to run against production server.

1. Run the frontend

   ```sh
   cd frontend
   npm run dev
   ```

2. Change baseUrl to `http://localhost:3000` in `cypress.config.ts`

3. Run Cypress
   ```sh
   npm run cy:run
   ```

### Chaos Toolkit

Production server should be up and running before running the experiment. See [Terraform](#terraform) section for more information.

1. Create virtual environment

   ```sh
   python3 -m venv ~/.venvs/chaostk
   source  ~/.venvs/chaostk/bin/activate
   ```

2. Install Chaos Toolkit

   ```sh
   pip install -U chaostoolkit
   ```

3. Install Chaos Toolkit for Azure

   ```sh
   pip install -U chaostoolkit-azure
   ```

4. Run the experiment
   ```sh
   cd chaos/ct00x
   chaos run experiment.json
   ```

### Terraform

1. Initialize Terraform
   ```sh
   cd iac/live
   terraform init
   ```
2. Create Terraform plan
   ```sh
   terraform plan -out main.tfplan
   ```
3. Apply Terraform plan
   ```sh
   terraform apply main.tfplan
   ```
4. Destroy Terraform plan for cleanup
   ```sh
   terraform destroy
   ```

## Workflow

Changes to main branch will trigger GitHub Actions workflow. This workflow consists of 3 jobs:

- Unit Test Terraform modules
- Run Terraform plan
- Deploy to Azure

Infrastructure deletion is not automated. It has to be done manually using Terraform destroy command.

## Roadmap

- [x] Frontend
  - [x] Register
  - [x] Login
  - [x] View Posts
  - [x] Create Post
  - [x] Update Post
  - [x] Delete Post
  - [x] Like Post
  - [x] Logout
- [x] Backend
  - [x] Register
  - [x] Login
  - [x] View Posts
  - [x] Create Post
  - [x] Update Post
  - [x] Delete Post
  - [x] Like Post
- [x] Cypress
  - [x] ST001
  - [x] ST002
  - [x] ST003
  - [x] ST004
  - [x] ST005
  - [x] ST006
  - [x] ST007
- [x] Terraform
  - [x] Bootstrap
  - [x] Live
    - [x] Virtual Network
    - [x] Network Security Group
    - [x] Application Gateway and Load Balancer
    - [x] NAT Gateway
    - [x] Azure Database for MySQL - Flexible Server
    - [x] Jumpbox Virtual Machine
    - [x] Frontend Virtual Machine Scale Sets
    - [x] Backend Virtual Machine Scale Sets
    - [x] Autoscaling Rules
- [x] Chaos Toolkit
  - [x] CT001
  - [x] CT002
  - [x] CT003

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

- [LinkedIn](https://www.linkedin.com/in/dickyrhermawan/)
- [Email](mailto:dickyrahmahermawan@gmail.com)

## Acknowledgements

- [Next.JS](https://nextjs.org/)
- [NextAuth.JS](https://next-auth.js.org/)
- [TailwindCSS](https://tailwindcss.com/)
- [Cypress](https://www.cypress.io/)
- [FastAPI](https://fastapi.tiangolo.com/)
- [Chaos Toolkit](https://github.com/chaostoolkit/chaostoolkit)
- [Chaos Toolkit for Azure](https://github.com/chaostoolkit-incubator/chaostoolkit-azure)
- [Terraform](https://www.terraform.io/)
