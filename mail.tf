## VPC 

# VPC
resource "aws_vpc" "VPC_1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "VPC_1"
  }
}

## Public Subnet

## public subnet
resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.0.0/24"

  availability_zone_id = "aps1-az1"

  tags = {
    Name = "public-subnet"
  }

  map_public_ip_on_launch = true
}

## Private Subnet
resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"

  availability_zone_id = "aps1-az1"

  tags = {
    Name = "private-subnet"
  }
}

## SG Group

Resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}



## Load Balancer

resource "aws_lb" "Public_LB" {
name = "my-alb"

 load_balancer_type = "application"

 vpc_id             = "vpc.id"
 subnets            = ["Public_subnet)"]
 security_groups    = ["allow_tls"]

  access_logs = {
    bucket = "my-alb-logs"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port                 = 443
      protocol             = "HTTPS"
      
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
      }
    }
  ]

  tags = {
    Environment = "DEV Public ALB"
  }
}


## Auto scaling Group:

resource "aws_autoscaling_group" "Instance" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.Instance.id
    version = aws_launch_template.Instance.latest_version
  }

  tag {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 60
    }
    triggers = ["tags"]
  }
}

data "aws_ami" "AMI" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "Amazon AMI"
    values = ["amzn-ami-hvm-*-x86_64-gp2"] ##(:AMI value based on customised requirement)
  }
}

resource "aws_launch_template" "Data AMI" {
  image_id      = data.aws_ami.AMI.id
  instance_type = "t2.macro" ##(:Type should be as per requirement. Free tier should help to avoid charges)
}

resource "aws_volume_attachment" "tc_ebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_tc_volume.ebs.id
  instance_id = aws_instance.Tomcat.id
}

resource "aws_instance" "Tomcat" {
  ami               = "ami-21f78e11"
  availability_zone = "us-east-1a"
  instance_type     = "t2.micro"

  tags = {
    Name = "TC_Volume"
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "us-east-1a"
  size              = 1
}


resource "aws_volume_attachment" "ebs" {
  device_name = "/dev/sdh"
  location = "/var/log"
  volume_id   = aws_ebs_tc_volume.ebs.id
  instance_id = aws_instance.Tomcat.id
}

resource "aws_instance" "Tomcat" {
  ami               = "ami-21f78e11"
  availability_zone = "us-east-1a"
  instance_type     = "t2.micro"

  tags = {
    Name = "TC_Volume"
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "us-east-1a"
  size              = 1
}
