# Secrets manager service to store enviornment credentials 

resource "aws_kms_key" "secrets_key" { 

description = "Key for encrypting secret manager secrets" 

is_enabled = true 

enable_key_rotation = true 

deletion_window_in_days = 30  

} 

resource "aws_secretsmanager_secret" "mig_credentials" { 

#checkov:skip=CKV2_AWS_57: rotation rules not enabled at this time 

name = "database-credentials" 

kms_key_id = aws_kms_key.secrets_key.arn 

} 


locals { 

db_credentials = file("${path.cwd}/secrets_manager/db_credentials.json") 

} 


resource "aws_secretsmanager_secret_version" "db-credentials" { 

secret_id = aws_secretsmanager_secret.mig_credentials.id 

secret_string = local.db_credentials 

} 


########## 

resource "aws_lambda_function" "secret_rotation_lambda" { // lambda function for secrets rotation 

#checkov:skip=CKV_AWS_116: Dead Letter Queue(DLQ) not required at this time 

#checkov:skip=CKV_AWS_272: code-signing vaidation not required at this time 

#checkov:skip=CKV_AWS_115: function-level concurrent execution limit not required 

#checkov:skip=CKV_AWS_50: X-ray tracing is not required at this time 

#checkov:skip=CKV_AWS_117: VPC configuration not required 

filename = "lambda_secret_function.zip" 

function_name = "secret_rotation_lambda" 

handler = "lambda_function.lambda_handler" 

runtime = "python3.9" 

memory_size = 128 

timeout = 10 

role = aws_iam_role.secret_rotation_lambda_role.arn 

} 

 
 

// lambda role 

resource "aws_iam_role" "secret_rotation_lambda_role" { 

name = "secret_rotation_lambda_role" 

assume_role_policy = <<EOF 

{ 

"Version": "2012-10-17", 

"Statement": [ 

{ 

"Effect": "Allow", 

"Principal": { 

"Service": "lambda.amazonaws.com" 

}, 

"Action": "sts:AssumeRole" 

} 

] 

} 

EOF 

} 


resource "aws_iam_role_policy_attachment" "secret_rotation_lambda_policy_attachment" { 

policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" 

role = aws_iam_role.secret_rotation_lambda_role.name 

} 


//rotation policy

resource "aws_secretsmanager_secret_rotation" "secrets_rotation" { //automates secrets rotation 

secret_id = aws_secretsmanager_secret.mig_credentials.id 

rotation_lambda_arn = aws_lambda_function.secret_rotation_lambda.arn 


rotation_rules { 

automatically_after_days = 30 

} 

} 