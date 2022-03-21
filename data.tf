data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "base-with-ansible"
  owners           = ["self"]
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tf-bucket-61"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "common2" {
  name = "common2/ssh"
}

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = data.aws_secretsmanager_secret.common2.id
}
data "aws_secretsmanager_secret" "dev" {
  name = "dev-env"
}

data "aws_secretsmanager_secret_version" "dev-secrets" {
  secret_id = data.aws_secretsmanager_secret.dev.id
}