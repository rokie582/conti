resource "aws_vpc" "main" {
    cidr_block = "10.1.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags {
        Name = "Continental-VPC"
    }
}

# Public Subnets
resource "aws_subnet" "PublicSubnetA" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.0.0/24"
    availability_zone = "eu-central-1a"
    map_public_ip_on_launch = "true"

    tags {
        Name = "Continental-PublicSubnetA"
    }
}

resource "aws_subnet" "PublicSubnetB" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.1.0/24"
    availability_zone = "eu-central-1b"
    map_public_ip_on_launch = "true"

    tags {
        Name = "Continental-PublicSubnetB"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "IGW" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "Continental-IGW"
    }
}

# Public Route Table
resource "aws_route_table" "PublicRouteTable" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW.id}"
    }

    tags {
        Name = "Continental-PublicRouteTable"
    }
}

# Public Route Table Association
resource "aws_route_table_association" "PRTA-1a" {
    subnet_id = "${aws_subnet.PublicSubnetA.id}"
    route_table_id = "${aws_route_table.PublicRouteTable.id}"
}

resource "aws_route_table_association" "PRTA-1b" {
    subnet_id = "${aws_subnet.PublicSubnetB.id}"
    route_table_id = "${aws_route_table.PublicRouteTable.id}"
}

#Private Subnets
resource "aws_subnet" "PrivateSubnetA" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.16.0/20"
    availability_zone = "eu-central-1a"

    tags {
        Name = "Continental-PrivateSubnetA"
    }
}

resource "aws_subnet" "PrivateSubnetB" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.32.0/20" 
    availability_zone = "eu-central-1b"

    tags {
        Name = "Continental-PrivateSubnetB"
    }
}

# Nat Gateway
resource "aws_eip" "nat-ip-1a" {
    vpc = true
}

resource "aws_eip" "nat-ip-1b" {
    vpc = true
}

resource "aws_nat_gateway" "NatGW-1a" {
    allocation_id = "${aws_eip.nat-ip-1a.id}"
    subnet_id = "${aws_subnet.PublicSubnetA.id}"
    depends_on = ["aws_internet_gateway.IGW"]

    tags {
        Name = "Continental-NatGW-1a"
    }
}

resource "aws_nat_gateway" "NatGW-1b" {
    allocation_id = "${aws_eip.nat-ip-1b.id}"
    subnet_id = "${aws_subnet.PublicSubnetB.id}"
    depends_on = ["aws_internet_gateway.IGW"]

    tags {
        Name = "Continental-NatGW-1b"
    }
}

# Private Route Table
resource "aws_route_table" "PrivateRouteTable-1a" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.NatGW-1a.id}"
    }

    tags {
        Name = "Continental-PrivateRouteTable-1a"
    }
}

resource "aws_route_table" "PrivateRouteTable-1b" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.NatGW-1b.id}"
    }

    tags {
        Name = "Continental-PrivateRouteTable-1b"
    }
}

# Private Route Table Association

resource "aws_route_table_association" "PriRTA-1a" {
    subnet_id = "${aws_subnet.PrivateSubnetA.id}"
    route_table_id = "${aws_route_table.PrivateRouteTable-1a.id}"
}

resource "aws_route_table_association" "PriRTA-1b" {
    subnet_id = "${aws_subnet.PrivateSubnetB.id}"
    route_table_id = "${aws_route_table.PrivateRouteTable-1b.id}"
}