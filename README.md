# AWS Security Services – Macie & Secrets Manager

This project demonstrates the use of AWS S3 and Macie to perform security scans on sample bucket data at regular intervals to identify sensitive data (e.g. PII) using Terraform (IaC). 

---

## 📦 Features

- Provisioned S3 bucket resources and  Macie 
- Created a macie classification job to perform security scans on a daily basis
- provisioned secret manager secrets to store environment credentials in AWS
- Used KMS keys to encrypt the secret manager secrets and setup rotation policies 
- Created a lambda function, lambda role and policy attachments for rotation purposes 

---
## ✅ Prerequisites

Before you begin, ensure the following tools and setup are in place:

- **Terraform ≥ 1.3**  
  _Used to provision AWS Macie, S3 resources, and Secrets Manager resources_

- **AWS CLI ≥ v2**  
  _Used to authentication to AWS and configure API keys locally_

- **An AWS account** with IAM permissions to create the following:  
  - S3 buckets  
  - Macie resources  
  - Secrets Manager secrets  
  - Lambda functions  
  - KMS keys 

---

## 📁 Project Structure

```bash
.
├── Macie/
│   ├── Macie.tf                 
│   └── Macie-data/
│       └── sample-data.csv      
│
├── Secrets-manager/
│   ├── secrets-manager.tf       
│   ├── lambda_secret_code_zip   
│   └── lambda_code/
│       └── lambda_secret_code_zip 
│
└── README.md
```

Macie: https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html

Secrets Manager: https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html


Repository Readme updated in 2025 to improve clarity and readability. The core project was originally built in 2023.
