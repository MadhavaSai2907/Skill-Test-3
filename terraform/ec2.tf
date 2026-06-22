resource "aws_instance" "ecommerce_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ecommerce_sg.id]


  tags = {
    Name = "ecommerce-server"
  }
}
