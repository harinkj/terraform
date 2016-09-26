provider "aws" {
  access_key = "AKIAJ7366FV3ONDHE3UA"
  secret_key = "a5RZGWpG1CfcGKhxn9zO0u7T9YFVHP4zqhYW6p9g"
  region     = "us-east-1"
}

resource "aws_instance" "example-harin" {
  ami           = "ami-13be557e"
  instance_type = "t2.micro"
}
