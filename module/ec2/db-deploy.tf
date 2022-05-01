resource "null_resource" "db-deploy" {
  triggers = {
    instance_ids = aws_spot_instance_request.db.spot_instance_id
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = local.SSH_USERNAME
      password = local.SSH_PASSWORD
      host     = aws_spot_instance_request.db.private_ip
    }

    inline = [
      "ansible-pull -U https://github.com/Madhu427/ansible.git roboshop-pull.yml -e COMPONENT=${var.DB_COMPONENT} -e ENV=${var.ENV}"
    ]

    on_failure = “continue”
  }
}


locals {
  SSH_USERNAME   = var.SSH_USERNAME
  SSH_PASSWORD   = var.SSH_PASSWORD
}