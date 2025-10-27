variable "regions" {
  type = list(string)
}

locals {
  regions = {for region in var.regions : region => region}
}