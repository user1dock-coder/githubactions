terraform {
  backend "s3" {
    bucket         = "clirishitha-terraform-state-use1"
    key            = "env/prod/groups/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
