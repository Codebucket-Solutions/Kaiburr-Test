provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "mongodb" {
  name        = "mongodb"
  description = "Firewall for MongoDB server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mongodb" {
  ami           = var.aws_ami
  instance_type = "t2.micro"
  key_name      = var.aws_key_name
  security_groups = [aws_security_group.mongodb.name]
  user_data = <<-EOF
    #!/bin/bash
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    sudo systemctl enable mongod
    sudo systemctl start mongod
    echo "mongodb-org hold" | sudo dpkg --set-selections
    echo "mongodb-org-server hold" | sudo dpkg --set-selections
    echo "mongodb-org-shell hold" | sudo dpkg --set-selections
    echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
    echo "mongodb-org-tools hold" | sudo dpkg --set-selections
  EOF
}

resource "random_string" "password" {
  length  = 32
  special = true
}

resource "aws_db_instance" "mongodb" {
  engine = "mongodb"
  engine_version = "4.4"
  instance_class = "db.t2.micro"
  name = "mydb"
  username = "mongouser"
  password = random_string.password.result
  publicly_accessible = false
  storage_type = "gp2"
  storage_size = 100
  vpc_security_group_ids = [aws_security_group.mongodb.id]
}

output "mongodb_endpoints" {
  value = aws_db_instance.mongodb.address
}

output "mongodb_username" {
  value = aws_db_instance.mongodb.username
}

output "mongodb_password" {
  value = aws_db_instance.mongodb.password
}
