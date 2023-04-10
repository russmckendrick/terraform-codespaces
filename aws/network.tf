resource "aws_security_group" "sg" {
  name   = var.name
  vpc_id = var.existing_vpc_id != "" ? var.existing_vpc_id : join("", aws_vpc.vpc.*.id)

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_security_group_rule" "egress_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.egress_cidr_blocks
  security_group_id = aws_security_group.sg.id
  description       = "Outbound"
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "SSH access"
}

resource "aws_security_group_rule" "jenkins" {
  type              = "ingress"
  from_port         = var.jenkins_port
  to_port           = var.jenkins_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "Jenkins access"
}
