resource "aws_instance" "ec2-demo" {
  ami           = "ami-04ff98ccbfa41c9ad"
  instance_type = "t2.micro"


  tags = {
    Name = "HelloWorld"
  }
}
