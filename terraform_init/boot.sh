terraform init

#load aws access vars from .secrets
export $(grep -E '^AWS_' ../.secrets | xargs) 

terraform apply -auto-approve

terraform_state_bucket=$(terraform output -raw s3_bucket_name)
#upload state to s3 bucket
aws s3 cp terraform.tfstate s3://$terraform_state_bucket/terraform.tfstate