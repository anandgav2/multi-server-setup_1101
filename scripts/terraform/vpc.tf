
# Security Group for Internal Communication 
resource "aws_security_group" "cip-multi-internal" {
  name        = "cip-multi-internal"
  description = "Security group for internal communication"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    self        = true 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true 
  }
}

# Security Group for External Communication 
resource "aws_security_group" "cip-multi-external" {
   name        = "cip-multi-external"
   description = "Security group for external communication"

  ingress {
    from_port   = 22  # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 6761  # Your desired port # AG
    to_port     = 6761
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 6961  # Your desired port # Cafe
    to_port     = 6961
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 6461  # Your desired port # CC
    to_port     = 6461
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 32400  # Your desired port  # CIPUI
    to_port     = 32400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 29000  # Your desired port #A360
    to_port     = 29092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

}



