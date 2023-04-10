data "aws_ami" "nodes" {
  owners      = [var.ami_owner_id]
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "template_file" "init_script" {
  template = file("${path.module}/resources/init.sh")

  vars = {
    docker_compose_conf   = file("${path.module}/resources/docker-compose.yml")
    jenkins_port          = var.jenkins_port
  }
}

data "template_cloudinit_config" "init" {
  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.init_script.rendered
  }
}
