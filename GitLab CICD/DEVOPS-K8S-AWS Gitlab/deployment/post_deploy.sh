#!/bin/bash
scp -i ~/.ssh/your-key.pem -r app/k8s ec2-user@<ec2-ip>:~/app/
scp -i ~/.ssh/your-key.pem -r monitoring ec2-user@<ec2-ip>:~/monitoring/

ssh -i ~/.ssh/your-key.pem ec2-user@<ec2-ip> << EOF
kubectl apply -f ~/app/k8s/
kubectl apply -f ~/monitoring/prometheus/deployment.yaml
kubectl apply -f ~/monitoring/grafana/deployment.yaml
EOF
