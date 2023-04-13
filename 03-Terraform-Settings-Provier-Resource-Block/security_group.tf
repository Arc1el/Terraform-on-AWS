resource "aws_security_group" "webserver-sg" {
    name = "webserver-sg"
    description = "allow 22, 80"
    vpc_id = aws_vpc.default.id

    tags = {
      "hmkim" = "security group"
    }
}

resource "aws_security_group_rule" "webserver-sg-ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.webserver-sg.id
    description = "ssh"
}

resource "aws_security_group_rule" "webserver-sg-http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.webserver-sg.id
    description = "http"
}

resource "aws_security_group_rule" "webserver-sg-outbound" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.webserver-sg.id
    description = "outbound"
}