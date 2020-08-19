resource "aws_instance" "PrivateInstance" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "PrivateKeyPair"
  subnet_id = "${aws_subnet.PrivateSubnetA.id}"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}", "${aws_security_group.allow-http.id}"]
}

resource "aws_instance" "PublicInstance" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "PrivateKeyPair"
  subnet_id = "${aws_subnet.PublicSubnetA.id}"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
}


resource "aws_lb" "my-alb" {
    name = "myapp-alb"
    internal = false
    load_balancer_type = "application"
    subnets = ["${aws_subnet.PublicSubnetA.id}", "${aws_subnet.PublicSubnetB.id}"]
    security_groups = ["${aws_security_group.allow-http.id}"]

    tags {
        Name = "my-alb"
    }
}

resource "aws_lb_target_group" "backend-tg" {
    name = "alb-target-group-backend"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_lb_target_group_attachment" "attach-backend-ec2" {
    target_group_arn = "${aws_lb_target_group.backend-tg.arn}"
    target_id = "${aws_instance.PrivateInstance.id}"
    port = 80
}

resource "aws_lb_listener" "backend-listners" {
    load_balancer_arn = "${aws_lb.my-alb.arn}"
    port = 80
    protocol = "HTTP"

    default_action = {
        target_group_arn = "${aws_lb_target_group.backend-tg.arn}"
        type = "forward"
    }

}