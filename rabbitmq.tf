module "rabbitmq" {
  source = "./module/ec2"
  SSH_USERNAME   = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_USERNAME"]
  SSH_PASSWORD   = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_PASSWORD"]
  COMPONENT      = var.COMPONENT
  ENV            = var.ENV
  AMI            = data.aws_ami.ami.id
  SUBNET_ID     = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS[0]
  PRIVATE_SUBNET_CIDR = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_CIDR
  ALL_SUBNET_CIDR = concat(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_CIDR, tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
  VPC_ID          = data.terraform_remote_state.vpc.outputs.VPC_ID
  PRIVATE_HOSTED_ZONE_ID = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_ID
  DB_COMPONENT = "rabbitmq"
  APP_PORT = 5672
  INSTANCE_TYPE = var.RABBITMQ_INSTANCE_TYPE
}
