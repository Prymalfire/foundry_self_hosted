data terraform_remote_state "vpc" {
    backend = "s3"
    config = {
        bucket = var.terraform_remote_state_bucket
        key    = "layer_0_vpc"
        region = "us-east-1"
    }
}

variable "terraform_remote_state_bucket" {
    description = "The S3 bucket where remote state is stored"
    type        = string
}