# End-to-End DevOps Pipeline - Real-time CI/CD, Docker + K3s with Self-Healing Microservices

This project demonstrates a complete DevOps pipeline with modern tools and best practices. It deploys a Python web app (frontend + backend) to a lightweight Kubernetes cluster (K3s) on AWS, using GitLab CI/CD and AWS ECR for container image management. Infrastructure is provisioned using Terraform.

## Project Overview

The infrastructure setup includes:

* Python web application with frontend and backend
* Lightweight K3s Kubernetes cluster on AWS EC2
* Automated provisioning with Terraform (VPC, EC2, Security Groups, AWS ECR)
* Real-time CI/CD with GitLab
* Kubernetes deployment with self-healing configurations (readiness/liveness probes)
* Ingress routing using NGINX
* Placeholder monitoring stack (Prometheus and Grafana)

## Technologies Used

* GitLab CI/CD
* Docker
* K3s (Kubernetes lightweight distro)
* AWS (EC2, ECR, VPC)
* Terraform
* Python (Flask)
* HTML/CSS (Frontend)
* Prometheus & Grafana (Monitoring - WIP)

## Repository Structure

```
.
├── app/
│   ├── k8s/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── static/
│   │   └── style.css
│   ├── templates/
│   │   └── index.html
│   ├── Dockerfile
│   ├── app.py
│   ├── requirements.txt
│   └── python-installer.exe
│
├── deployment/
│   ├── install_k3s.sh
│   └── post_deploy.sh
│
├── k8s/
│   ├── ingress.yaml
│   └── namespace.yaml
│
├── monitoring/
│   ├── grafana/
│   └── prometheus/
│
├── terraform/
│   ├── ec2.tf
│   ├── ecr.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── security_groups.tf
│   └── vpc.tf
│
├── .gitlab-ci.yml
└── README.md
```

## Getting Started

### Prerequisites

* AWS Account with IAM user (programmatic access)
* Terraform installed
* GitLab repository for pipeline setup
* EC2 SSH Key Pair (.pem file)

### Step 1: Provision Infrastructure with Terraform

```bash
cd terraform
terraform init
terraform apply
```

Resources provisioned:

* EC2 instance
* VPC and networking
* Security groups
* ECR repository

### Step 2: Install K3s on EC2

SSH into the EC2 instance:

```bash
ssh -i devops-k3s.pem ec2-user@<ec2-public-ip>
```

Run K3s install script:

```bash
cd deployment
bash install_k3s.sh
```

### Step 3: Deploy Kubernetes Manifests

Transfer K8s manifests to EC2:

```bash
scp -i devops-k3s.pem -r k8s/ ec2-user@<ec2-ip>:~/
scp -i devops-k3s.pem -r app/k8s ec2-user@<ec2-ip>:~/app-k8s
```

Apply resources:

```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl apply -f ~/k8s/namespace.yaml
kubectl apply -n devops-app -f ~/app-k8s/deployment.yaml
kubectl apply -n devops-app -f ~/app-k8s/service.yaml
kubectl apply -n devops-app -f ~/k8s/ingress.yaml
```

### Step 4: Configure Ingress and Access Application

Install Ingress controller:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/baremetal/deploy.yaml
```

Access the app:

```
http://<ec2-ip>.nip.io
```

### Step 5: CI/CD with GitLab

Set the following GitLab CI/CD variables:

| Variable Name           | Description      |
| ----------------------- | ---------------- |
| `AWS_ACCESS_KEY_ID`     | AWS Access Key   |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key   |
| `AWS_DEFAULT_REGION`    | e.g., us-east-1  |
| `ECR_REPO`              | AWS ECR repo URI |

Pipeline stages defined in `.gitlab-ci.yml`:

* Build Docker image
* Push to ECR
* SSH and deploy to K3s

## Key Highlights

* Self-healing microservices via readiness/liveness probes
* Automated full pipeline from commit to deployment
* Clean and modular repo structure
* ECR used for image registry (not Docker Hub)
* K3s used to stay within AWS free tier limits

## Acknowledgments

This project was built using best practices in multi-cloud DevOps engineering and serves as a foundational template for real-world deployments.

---

## License

This project is licensed under the MIT License.

Authored by Harshal Thakur
