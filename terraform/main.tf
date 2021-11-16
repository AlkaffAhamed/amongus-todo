variable "name" {
  type    = string
  default = "dev-tools-amongus"
}

locals {
  ami_id        = "ami-0f511ead81ccde020"
  instance_type = "t2.micro"
}

# https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/examples/complete
#############################################################
# Data sources to get VPC and default security group details
#############################################################
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "amongus" {
  name   = "amongus"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "rule_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.amongus.id
}

resource "aws_security_group_rule" "rule_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.amongus.id
}

resource "aws_instance" "amongus_server" {
  ami                         = local.ami_id
  instance_type               = local.instance_type

  tags = {
    Name = var.name
  }

  vpc_security_group_ids = [aws_security_group.amongus.id]
  key_name = "amongus"

  # https://stackoverflow.com/questions/64809479/in-terraform-how-can-i-pull-a-docker-image-on-the-target
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum update -y",
  #     "sudo yum install git -y",
  #     "sudo yum install docker -y",
  #     "sudo service docker start",
  #     # "sudo usermod -a -G docker ec2-user",
  #     # "sudo curl -L \"https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
  #     # "sudo chmod +x /usr/local/bin/docker-compose",
  #     "docker pull alkaffahamed/amongus-capstone:test",
  #     "docker run --name amongus_server -d -p 22:22 -p 3000:3000 alkaffahamed/amongus-capstone:test",
  #     "docker port amongus_server",
  #     "docker exec -it amongus_server bash"
  #   ]
  # }

  # connection {
  #   host        = coalesce(self.public_ip, self.private_ip)
  #   agent       = true
  #   type        = "ssh"
  #   user        = "ec2-user"
  #   private_key = "amongus" #file(pathexpand("~/.ssh/id_rsa"))
  # }
}

output "instance_id" {
  value = aws_instance.amongus_server.id
}

output "instance_ip_public" {
  value = aws_instance.amongus_server.public_ip
}

output "instance_ip_private" {
  value = aws_instance.amongus_server.private_ip
}
