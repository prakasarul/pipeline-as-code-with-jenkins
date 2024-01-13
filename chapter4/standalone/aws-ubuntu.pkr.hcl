packer {
    required_plugins {
      amazon = {
        version = ">= 1.2.8"
        source  = "github.com/hashicorp/amazon"
      }
    }
  }
  
  source "amazon-ebs" "ubuntu" {
    ami_name      = "learn-packer-linux-aws"
    instance_type = "t2.micro"
    region        = "us-east-1"
    source_ami_filter {
      filters = {
        name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
        root-device-type    = "ebs"
        virtualization-type = "hvm"
      }
      most_recent = true
      owners      = ["099720109477"]
    }
    ssh_username = "ubuntu"
  }
  
  build {
    name    = "learn-packer"
    sources = [
      "source.amazon-ebs.ubuntu"
    ]
    provisioner "shell" {
      environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Install Jenkins stable release $FOO",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install jenkins -y",
      "systemctl enable jenkins",
      "systemctl start jenkins",
    ]
  }

  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }
    
  }

  }
  
  