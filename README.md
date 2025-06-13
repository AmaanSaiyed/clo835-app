
# CLO835 Assignment: Containerized Flask App Deployment on AWS
```
This project demonstrates how to build and deploy a multi-container Flask web application and MySQL database using Docker, Amazon ECR, EC2, Terraform, and GitHub Actions.

```
## Project Structure

```
clo835-app/
├── app/                # Flask web application
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── templates/
├── mysql/              # MySQL container
│   ├── init.sql
│   └── Dockerfile
├── terraform/          # Infrastructure as Code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── user\_data.sh
│   └── amaantemp.pem
└── .github/
└── workflows/
└── deploy.yml  # CI/CD pipeline

````

---

## Prerequisites

- AWS Cloud9 environment (VocLabs)
- Docker & AWS CLI installed on EC2 instance
- Terraform installed on Cloud9
- GitHub repository with the following secrets set:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_SESSION_TOKEN`
- IAM Role: `LabRole` and instance profile: `LabInstanceProfile` (with ECR access)

---

## Deployment Steps

### 1. Deploy AWS Infrastructure with Terraform

```bash
cd terraform/
terraform init
terraform apply -auto-approve
````

---

### 2. Build & Push Docker Images with GitHub Actions

Push to the `main` branch to trigger the CI/CD workflow:

```bash
git add .
git commit -m "Initial deployment"
git push origin main
```

---

### 3. Connect to EC2 Instance

```bash
ssh -i ~/.ssh/amaantemp.pem ec2-user@<EC2_PUBLIC_IP>
```

---

### 4. Install & Start Docker on EC2

```bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
exit
```

---

### 5. Authenticate Docker to Amazon ECR

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.us-east-1.amazonaws.com
```

---

### 6. Pull Docker Images from ECR

```bash
docker pull <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/clo835-webapp:latest
docker pull <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/clo835-mysql:latest
```

---

### 7. Create Docker Network

```bash
docker network create my-app-network
```

---

### 8. Run MySQL Container

```bash
docker run -d --network my-app-network --name mysql-container \
-e MYSQL_ROOT_PASSWORD=password \
-e MYSQL_DATABASE=employees \
<your-account-id>.dkr.ecr.us-east-1.amazonaws.com/clo835-mysql:latest
```

---

### 9. Run Flask Web App Containers

```bash
docker run -d --network my-app-network --name blue-container \
-p 8081:8080 \
-e DB_HOST=mysql-container \
-e DB_NAME=employees \
-e DB_USER=root \
-e DB_PASSWORD=password \
-e BACKGROUND_COLOR=blue \
<your-account-id>.dkr.ecr.us-east-1.amazonaws.com/clo835-webapp:latest

docker run -d --network my-app-network --name pink-container \
-p 8082:8080 \
-e DB_HOST=mysql-container \
-e DB_NAME=employees \
-e DB_USER=root \
-e DB_PASSWORD=password \
-e BACKGROUND_COLOR=pink \
<your-account-id>.dkr.ecr.us-east-1.amazonaws.com/clo835-webapp:latest

docker run -d --network my-app-network --name lime-container \
-p 8083:8080 \
-e DB_HOST=mysql-container \
-e DB_NAME=employees \
-e DB_USER=root \
-e DB_PASSWORD=password \
-e BACKGROUND_COLOR=lime \
<your-account-id>.dkr.ecr.us-east-1.amazonaws.com/clo835-webapp:latest
```

---

## Application Access

* `http://<EC2_PUBLIC_IP>:8081` → Blue container
* `http://<EC2_PUBLIC_IP>:8082` → Pink container
* `http://<EC2_PUBLIC_IP>:8083` → Lime container

---

## API Endpoints

### `/health`

```http
GET http://<EC2_PUBLIC_IP>:8081/health
```

Response:

```json
{
  "status": "healthy",
  "background": "blue"
}
```

---

### `/db-test`

```http
GET http://<EC2_PUBLIC_IP>:8081/db-test
```

Response:

```
Database connected! Employee count: 30
```

---

## Container Debugging Commands

```bash
docker exec -it mysql-container mysql -uroot -ppassword -e "SHOW DATABASES;"
docker exec -it blue-container ping mysql-container
docker ps
```

---

## Teardown Infrastructure

```bash
cd terraform/
terraform destroy -auto-approve
```

If ECR repository deletion fails, manually delete images in AWS Console or set `force_delete = true` in Terraform ECR resource.

---


## 👨‍💻 Author

**Amaan Saiyed**
Seneca College – CLO835
Summer 2025
GitHub: [@AmaanSaiyed](https://github.com/AmaanSaiyed)

---



