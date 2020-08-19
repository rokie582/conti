resource "aws_security_group" "allow-mysql" {
    vpc_id = "${aws_vpc.main.id}"
    name = "allow-mysql"
    description = "SG for MYSQL"

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "TCP"
        security_groups = ["${aws_security_group.allow-ssh.id}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks=["0.0.0.0/0"]
        self = true 
    }

    tags {
        Name = "MYSQLDB-SG"
    }
}

resource "aws_security_group" "allow-ssh" {
    vpc_id = "${aws_vpc.main.id}"
    name = "allow-ssh"
    description = "SG for ssh access"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks=["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks=["0.0.0.0/0"]

    }

    tags {
        Name = "Continental SSH SG"
    }

}

resource "aws_security_group" "allow-http" {
    vpc_id = "${aws_vpc.main.id}"
    name = "conti-allow-http"
    description = "SG for http"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks=["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks=["0.0.0.0/0"]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags {
        Name = "Allow-HTTP"
    }
}