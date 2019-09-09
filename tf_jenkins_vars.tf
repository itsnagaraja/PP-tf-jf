variable "region" {
    default = "us-east-2"
}
variable "vpc_id" {
    default = "vpc-82759ce9"
}
variable "subnet_id" {
    default = "subnet-5c7acc10"
}

variable "ports" {
    type = "list"
    default = ["22", "8080", 0]
}

variable "ami" {
    type = "map"
    default = {
        "us-east-1" = "ami-07d0cf3af28718ef8"
        "us-east-2" = "ami-05c1fa8df71875112"
        "us-west-1" = "ami-08fd8ae3806f09a08"
        "us-west-2" = "ami-06f2f779464715dc5"
        "ap-south-1" = "ami-009110a2bf8d7dd0a"
    }
}
variable "cidr_block_all_traffic" {
    default = "0.0.0.0/0"
}
variable "key_pair_name" {
    default = "tomcat_ec2_key"
}

variable "instance_type" {
    default = "t2.micro" 
}

variable "tags"{
    type = "list"
    default = ["Server"]
}

output "tomcat_public_ip" {
  value = "${aws_instance.TomcatServer.*.public_ip}"
}

output "tomcat_private_ip" {
  value = "${aws_instance.TomcatServer.*.private_ip}"
}

output "tomcat_public_dns" {
  value = "${aws_instance.TomcatServer.*.public_dns}"
}

output "tomcat_private_dns" {
  value = "${aws_instance.TomcatServer.*.private_dns}"
}
