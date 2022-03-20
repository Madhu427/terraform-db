resource "null_resource" "db-deploy" {
  triggers = {
    instance_ids = join(",", aws_spot_instance_request.db.*.spot_instance_id)
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = local.SSH_USERNAME
      password = local.SSH_PASSWORD
      host     = aws_spot_instance_request.db.private_ip
    }

    inline = [
      "ansible-pull -i  localhost, -U https://github.com/Madhu427/ansible.git roboshop.yml -e COMPONENT=${var.DB_COMPONENT} -e ENV=${var.ENV}"
    ]
  }
}


locals {
  SSH_USERNAME   = var.SSH_USERNAME
  SSH_PASSWORD   = var.SSH_PASSWORD
}