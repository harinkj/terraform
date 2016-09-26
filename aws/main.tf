provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-1"
}
/*
resource "aws_instance" "ec2instance-east1" {
  ami           = "ami-0d729a60"
  instance_type = "t2.micro"
  tags {
    Name = "HelloWorld"
  }
}*/
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" { }
data "aws_ip_ranges" "us_ec2" {
  regions = [ "us-west-1", "us-east-1" ]
  services = [ "ec2" ]
}
resource "aws_cloudformation_stack" "network" {
  name = "networking-stack"
  template_body = <<STACK
{
  "Resources" : {
    "testvpc": {
      "Type" : "AWS::EC2::VPC",
      "Properties" : {
        "CidrBlock" : "10.0.0.0/16",
        "Tags" : [
          {"Key": "Name", "Value": "test_VPC"}
        ]
      }
    }
  }
}
STACK
}
output "zones" {
  value = ["${data.aws_availability_zones.available.names}"]
}
output "ident" {
  value = "${data.aws_caller_identity.current.account_id}"
}
output "iprange" {
  value = ["${data.aws_ip_ranges.us_ec2.cidr_blocks}"]
}
