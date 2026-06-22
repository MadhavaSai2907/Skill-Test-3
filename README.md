# Deploy a Multi-Service Node.js E-Commerce Application Using Terraform and Docker

## Overview

This project demonstrates the deployment of a microservices-based Node.js E-Commerce application on AWS using Terraform for infrastructure provisioning and Docker for containerization.

The application consists of:

* Frontend Service
* User Service
* Product Service
* Cart Service
* Order Service
* MongoDB Database

All services are containerized using Docker and deployed on an AWS EC2 instance provisioned through Terraform.

---

# Architecture

```text
Internet
    │
    ▼
AWS EC2 (Ubuntu)
    │
    ├── Frontend Service    (Port 3000)
    ├── User Service        (Port 3001)
    ├── Product Service     (Port 3002)
    ├── Cart Service        (Port 3003)
    ├── Order Service       (Port 3004)
    └── MongoDB             (Port 27017)
```

---

# Technologies Used

* Node.js
* Express.js
* MongoDB
* Docker
* Docker Hub
* Terraform
* AWS EC2
* AWS VPC
* AWS Security Groups

---

# Project Structure

```text
ecommerce-microservices/
├── backend/
│   ├── user-service/
│   ├── product-service/
│   ├── cart-service/
│   └── order-service/
│
├── frontend/
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── security-group.tf
│   ├── ec2.tf
│   └── outputs.tf
│
└── README.md
```

---

## Application Setup and Dockerization

## Objective

Containerize all application services using Docker and verify they run successfully on the local machine before deployment to AWS.

---

## Services

The application consists of the following services:

| Service         | Port  |
| --------------- | ----- |
| Frontend        | 3000  |
| User Service    | 3001  |
| Product Service | 3002  |
| Cart Service    | 3003  |
| Order Service   | 3004  |
| MongoDB         | 27017 |

---

## Dockerfile Creation

A Dockerfile was created inside each service directory.

Dockerfiles were created for:
* user-service
* product-service
* cart-service
* order-service
* frontend

---

## Building Docker Images

### User Service

```bash
docker build -t user-service:v1 .
```

### Product Service

```bash
docker build -t product-service:v1 .
```

### Cart Service

```bash
docker build -t cart-service:v1 .
```

### Order Service

```bash
docker build -t order-service:v1 .
```

### Frontend

```bash
docker build -t frontend:v1 .
```

---

## Verification

Health endpoints were tested locally:

```text
http://localhost:3001/health
```
<img width="802" height="412" alt="Screenshot 2026-06-21 171353" src="https://github.com/user-attachments/assets/0003a9db-a425-4ec2-a75b-9ec3fecbb690" />

```text
http://localhost:3002/health
```
<img width="881" height="420" alt="Screenshot 2026-06-21 171413" src="https://github.com/user-attachments/assets/b28d05f4-79a1-4dfb-8b6d-18543931110c" />

```text
http://localhost:3003/health
```
<img width="617" height="357" alt="Screenshot 2026-06-21 171428" src="https://github.com/user-attachments/assets/407ca153-13f6-402b-8027-ab73caeb2371" />


```text
http://localhost:3004/health
```
<img width="635" height="366" alt="Screenshot 2026-06-21 171442" src="https://github.com/user-attachments/assets/ea30ed15-a22e-4dfe-98bc-6933f08c6902" />

Frontend was verified at:

```text
http://localhost:3000
```
<img width="1912" height="1021" alt="Screenshot 2026-06-21 171311" src="https://github.com/user-attachments/assets/2803dfa2-cf70-41a5-91e5-36afbaa14d9b" />

---

## Docker Hub Push

### Login

```bash
docker login
```

### Tag Images

```bash
docker tag user-service:v1 madhavasai2907/user-service:v1
docker tag product-service:v1 madhavasai2907/product-service:v1
docker tag cart-service:v1 madhavasai2907/cart-service:v1
docker tag order-service:v1 madhavasai2907/order-service:v1
docker tag frontend:v1 madhavasai2907/frontend:v1
```

### Push Images

```bash
docker push madhavasai2907/user-service:v1
docker push madhavasai2907/product-service:v1
docker push madhavasai2907/cart-service:v1
docker push madhavasai2907/order-service:v1
docker push madhavasai2907/frontend:v1
```
<img width="1901" height="461" alt="dokcerhub" src="https://github.com/user-attachments/assets/f2b0db09-582c-460d-a749-3509dace3253" />

---

# Infrastructure Provisioning Using Terraform

Terraform provisions the following AWS resources:

## VPC

* CIDR Block: 10.0.0.0/16

## Public Subnet

* CIDR Block: 10.0.1.0/24

## Internet Gateway

Provides internet access to resources inside the VPC.

## Route Table

Routes internet traffic through the Internet Gateway.

## Security Group

Allowed Ports:

| Port | Purpose         |
| ---- | --------------- |
| 22   | SSH             |
| 3000 | Frontend        |
| 3001 | User Service    |
| 3002 | Product Service |
| 3003 | Cart Service    |
| 3004 | Order Service   |

## EC2 Instance

| Property      | Value                 |
| ------------- | --------------------- |
| AMI           | ami-01a00762f46d584a1 |
| Instance Type | t3.small              |
| Region        | ap-south-1            |

---

# Terraform Deployment

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Review Execution Plan

```bash
terraform plan
```

## Deploy Infrastructure

```bash
terraform apply
```
<img width="1857" height="511" alt="Screenshot 2026-06-21 194340" src="https://github.com/user-attachments/assets/e262cd98-a59c-4d4b-b46b-151b163b4563" />

## Destroy Infrastructure

Once everything is tested, use below command to destory infa created using terraform.

```bash
terraform destroy
```
<img width="816" height="257" alt="Screenshot 2026-06-21 194039" src="https://github.com/user-attachments/assets/91497312-955f-4dd0-af34-583e0a51da85" />

---

# Docker Deployment on EC2

## Create Docker Network

```bash
docker network create ecommerce-network
```

## Run MongoDB

```bash
docker run -d \
--name mongodb \
--network ecommerce-network \
mongo:latest
```

## Run User Service

```bash
docker run -d \
--name user-service \
--network ecommerce-network \
-p 3001:3001 \
-e MONGODB_URI=mongodb://mongodb:27017/ecommerce_users \
madhavasai2907/user-service:v1
```

## Run Product Service

```bash
docker run -d \
--name product-service \
--network ecommerce-network \
-p 3002:3002 \
-e MONGODB_URI=mongodb://mongodb:27017/ecommerce_products \
madhavasai2907/product-service:v1
```

## Run Cart Service

```bash
docker run -d \
--name cart-service \
--network ecommerce-network \
-p 3003:3003 \
-e MONGODB_URI=mongodb://mongodb:27017/ecommerce_carts \
-e PRODUCT_SERVICE_URL=http://product-service:3002 \
madhavasai2907/cart-service:v1
```

## Run Order Service

```bash
docker run -d \
--name order-service \
--network ecommerce-network \
-p 3004:3004 \
-e MONGODB_URI=mongodb://mongodb:27017/ecommerce_orders \
-e PRODUCT_SERVICE_URL=http://product-service:3002 \
madhavasai2907/order-service:v1
```

## Run Frontend

```bash
docker run -d \
--name frontend \
--network ecommerce-network \
-p 3000:3000 \
madhavasai2907/frontend:v1
```
<img width="1902" height="915" alt="Screenshot 2026-06-21 195345" src="https://github.com/user-attachments/assets/5947f2b8-d5b7-4f02-8ede-859adaf73640" />

---

# Verification

## Check Running Containers

```bash
docker ps
```

## Check Logs

```bash
docker logs user-service
docker logs product-service
docker logs cart-service
docker logs order-service
docker logs frontend
```

---

# Application URLs


## Frontend

```text
http://13.235.9.106:3000
```
<img width="1906" height="966" alt="ec2-1" src="https://github.com/user-attachments/assets/adfa4537-2f5b-4603-adea-bbd8839bd636" />


## User Service

```text
http://13.235.9.106:3001/health
```
<img width="630" height="362" alt="3001" src="https://github.com/user-attachments/assets/015886e2-78ba-456f-8183-0f57f63be0ec" />


## Product Service

```text
http://13.235.9.106:3002/health
```
<img width="737" height="261" alt="3002" src="https://github.com/user-attachments/assets/ec7a7b95-8d89-4ba5-b215-66e20bbb9643" />

## Cart Service

```text
http://13.235.9.106:3003/health
```
<img width="771" height="312" alt="3003" src="https://github.com/user-attachments/assets/75492ca0-3831-4bc7-b0e8-e6f5de4b9dbc" />

## Order Service

```text
http://13.235.9.106:3004/health
```
<img width="637" height="257" alt="3004" src="https://github.com/user-attachments/assets/7fd25163-212f-4cda-963e-cc2394a73d79" />

---

## Outcome

Successfully deployed a containerized Node.js E-Commerce Microservices Application on AWS using Terraform and Docker.

Achievements:

* Created Dockerfiles for all services
* Built and pushed images to Docker Hub
* Provisioned AWS infrastructure using Terraform
* Configured networking and security groups
* Deployed MongoDB and application containers on EC2
* Verified frontend and backend service accessibility
* Achieved end-to-end deployment automation and accessibility

---

