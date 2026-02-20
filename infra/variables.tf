variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging/naming"
  default     = "aws-terraform-cicd-pipeline"
}
