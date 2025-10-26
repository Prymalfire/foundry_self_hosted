variable "regions" {
  description = "List of regions to deploy resources in."
  type        = list(string)
  default     = ["us-east-1", "ap-southeast-2"]
}