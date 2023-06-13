# AWS-Security-Services Macie/Secrets-manager

Provisioned S3 bucket Macie resources using terraform in AWS

Created a macie classification job to peform security scans on the sample data on a daily basis

Provisioned secret manager secrets to store environment credentials in AWS

Used KMS keys to encrypt the secret and setup key and rotation policies.

Created a lambda function, lambda role and policy attachment using terraform for the secrets rotation
