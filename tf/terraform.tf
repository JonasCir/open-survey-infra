terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.14"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}


resource "aws_key_pair" "cirotzki_ssh" {
  key_name   = "jonas.cirotzki"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyv0cfFen9nPd4OceNVwxst35ONXQ2+0oaWORVsoZK2iLHGz2pVTQPt3gXNbeSrVhASXQyYOanGdOIUdR9ljiTOVliczFfvO96RcBLpTg3LPNkw3DA3MloHw0Z63j3gqJTsy4+KwnbkSTZ6UccFRa5t7NhUf84G6r0LolnZPF7tSibmwi6cEF0eOo4PxkaKU9Mj1uxO8BMc4bpgJ4Qd5kRHRaaum66I7n6karGHvfbAIAlP0iTcVmLYVxCSut5j3j+4M9AG6JXrSxPTBMcg5xndYCgSTwDaGvN/j8fA0mKs6W/RtnlvPP5CLn4/Q5rDNlozNKBkUqWqab8KZHHIrJAaC6oDC8u5UuChyPLumtt0iC83ligd3nSywbzPcxkHT412obWn9EkWIa4de6wzMnKyOMPUtshUkfWlHT+y3LWIG1d7Q81p+EBGPeI9m3jGcnHoLQ7TXHpVYDTJ5d83pYP0ewZAPdbSCdlox02XVasvzhwlvGuceKbprA+Nj8PvsdtJKNcD57UhB2IGVHZ14+W4uqHE/sF/qA8lfWhQSF81gZQ7j1lJlg7A576o/bN1wfZ5qgbTGLtYGo7/K9jmtEMUs39aGXrvj7mXrBrOraddhsSZcvX7muNbZ4dho+3ZBrl2gyrh99n0r2CwNFw4pCItm8sufZac4AA0kUbBAmtGQ== s8jociro@stud.uni-saarland.de"
  tags = merge(var.default_tags, {
    "Name" : "Main SSH key"
  })
}

resource "aws_security_group" "sdp_firewall" {
  name = "sdp_firewall"
  tags = merge(
    var.default_tags,
    {
      "Name" : "Main SDP Security Group"
    },
  )
}

resource "aws_security_group_rule" "egress_all" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.sdp_firewall.id
}

resource "aws_security_group_rule" "ssh_ingress_all" {
  type      = "ingress"
  from_port = 22
  protocol  = "tcp"
  to_port   = 22
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.sdp_firewall.id
}

resource "aws_security_group_rule" "http_ingress_all" {
  type      = "ingress"
  from_port = 80
  protocol  = "tcp"
  to_port   = 80
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.sdp_firewall.id
}

resource "aws_security_group_rule" "https_ingress_all" {
  type      = "ingress"
  from_port = 443
  protocol  = "tcp"
  to_port   = 443
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.sdp_firewall.id
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.sdp.id
  vpc      = false
  tags = merge(var.default_tags, {
    "Name" : "Static IP for deployment",
  })
}

resource "aws_instance" "sdp" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.cirotzki_ssh.key_name

  root_block_device {
    volume_size = 16
  }
  volume_tags = merge(var.default_tags, {
    "Name" : "Main storage for SDP"
  })

  security_groups = [
    aws_security_group.sdp_firewall.name
  ]

  tags = merge(var.default_tags, {
    "Name" : "Main SDP EC2 instance",
    "ansible_managed" : "true"
  })
}
