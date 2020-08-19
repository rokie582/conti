resource "aws_db_subnet_group" "mysql-sg" {
    name = "mysql-sg"
    description = "SG for RDS"
    subnet_ids = ["${aws_subnet.PrivateSubnetA.id}", "${aws_subnet.PrivateSubnetB.id}"]
}

resource "aws_db_parameter_group" "mysql-params" {
    name = "mysql-params"
    description = "MYSQL Params"
    family = "mysql5.7"

    parameter {
        name = "max_allowed_packet"
        value = "16777216"
    }

}

resource "aws_db_instance" "mysql" {
    allocated_storage = 20
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    identifier = "mysql"
    name = "ContiMysql"
    username = "admin"
    password = "password123"
    db_subnet_group_name = "${aws_db_subnet_group.mysql-sg.name}"
    parameter_group_name = "mysql-params"
    multi_az = "false"
    vpc_security_group_ids = ["${aws_security_group.allow-mysql.id}"]
    storage_type = "gp2"
    backup_retention_period = 30
    availability_zone = "${aws_subnet.PrivateSubnetA.availability_zone}"

    tags {
        Name = "Continental-MYSQL"
    }


}