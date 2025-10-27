data terraform_remote_state "networking" {
    backend = "s3"
    config = {
        bucket = var.terraform_remote_state_bucket
        key    = "layer_1_networking"
        region = "us-east-1"
    }
}

data terraform_remote_state "storage" {
    backend = "s3"
    config = {
        bucket = var.terraform_remote_state_bucket
        key    = "layer_2_storage"
        region = "us-east-1"
    }
}

variable "terraform_remote_state_bucket" {
    description = "The S3 bucket where remote state is stored"
    type        = string
}