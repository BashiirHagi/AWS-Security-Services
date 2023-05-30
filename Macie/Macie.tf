# Macie service for sensitive data discovery 

# Test S3 bucket 

resource "aws_kms_key" "S3_key" { 

description = "Key for S3 encryption" 

is_enabled = true 

enable_key_rotation = true 

deletion_window_in_days = 30 

} 

resource "aws_s3_bucket" "test_bucket" { 

#checkov:skip=CKV2_AWS_6:public access block not required  

#checkov:skip=CKV2_AWS_62:Notifications not needed 

#checkov:skip=CKV2_AWS_61:Lifecycle not needed 

#checkov:skip=CKV_AWS_144:cross-region replication not required  

bucket = "macie-sample-data" 

versioning { 

enabled = true 

} 
} 

resource "aws_s3_bucket_object" "test_data" { 

#checkov:skip=CKV_AWS_186:CMK encryption is not required at this time 

bucket = aws_s3_bucket.test_bucket.id 

key = "sample-data.csv" 

source = "${path.cwd}/macie-data/sample-data.csv" 

} 

resource "aws_s3_bucket_server_side_encryption_configuration" "test_sse" { 

bucket = aws_s3_bucket.test_bucket.id 

rule { 

apply_server_side_encryption_by_default { 

kms_master_key_id = aws_kms_key.S3_key.arn 

sse_algorithm = "aws:kms" 

} 

} 

} 

 
resource "aws_kms_key" "logs_S3_key" { 

description = "Key for S3 encryption" 

is_enabled = true 

enable_key_rotation = true 

deletion_window_in_days = 30 

} 

resource "aws_s3_bucket" "log_bucket" { 

#checkov:skip=CKV2_AWS_6:public access block not required  

#checkov:skip=CKV2_AWS_62:Notifications not needed 

#checkov:skip=CKV_AWS_21:Versioning not required 

#checkov:skip=CKV2_AWS_61:Lifecycle not needed 

#checkov:skip=CKV_AWS_144:cross-region replication not required 

bucket = "macie-logs" 

} 

resource "aws_s3_bucket_server_side_encryption_configuration" "logs_sse" { 

bucket = aws_s3_bucket.log_bucket.id 

rule { 

apply_server_side_encryption_by_default { 

kms_master_key_id = aws_kms_key.logs_S3_key.arn 

sse_algorithm = "aws:kms" 

} 

} 

} 

resource "aws_s3_bucket_logging" "log_bucket" { 

bucket = aws_s3_bucket.log_bucket.id 

target_bucket = aws_s3_bucket.log_bucket.id 

target_prefix = "log/" 

} 

# Macie discovery job for S3 bucket data  

resource "aws_macie2_classification_job" "macie_job" { 

job_type = "SCHEDULED" 

name = "macie jobs for S3" 

schedule_frequency { 

daily_schedule = true 

} 

s3_job_definition { 

bucket_definitions { 

account_id = var.aws_account_id 

buckets = [aws_s3_bucket.test_bucket.id, aws_s3_bucket.primary_s3_bucket.id, aws_s3_bucket.secondary_s3_bucket.id] 

} 

} 

} 
