terraform {
  backend "s3" {
    bucket         = "tfstate-paras-cicd-eu-west-2"
    key            = "aws-terraform-cicd-pipeline/infra.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
