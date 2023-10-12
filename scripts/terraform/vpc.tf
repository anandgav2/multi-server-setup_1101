

resource "aws_security_group" "cip-multi" {
   name        = "cip-multi"
   description = "Allow TCP inbound traffic"

  ingress {
    from_port   = 22  # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 5678  # Your desired port
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 6461  # Your desired port
    to_port     = 6461
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
    from_port   = 32400  # Your desired port # Cafe
    to_port     = 32400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 15000  # Your desired port
    to_port     = 35000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

  ingress {
    from_port   = 29000  # Your desired port
    to_port     = 29092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP range for better security
  }

}

resource "aws_security_group_rule" "cip_allow_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cip-multi.id
} 



