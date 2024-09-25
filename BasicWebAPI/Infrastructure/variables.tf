variable "docker_installation_script" {
  type    = string
  default = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install docker
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo chkconfig docker on
  EOF
}