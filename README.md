# Continental Assignment

## Architecture
1. Public Subnet with Public LB routing traffic to backend UI flask node in private subnet serving graph
2. MYSQL DB stores data in Private Subnet
3. Private Subnet with 2 nodes (microservices) - 1. UI flask node serving graph from MYSQL DB and 2. Back end node pulling data from endpoint and saving data in DB
4. infrastructure provisioned with Terraform

## Improvements
1. Backend node pulling data from endpoint should be converted to a lambda function triggered by a cloudwatch events every 2 mins and store data in my sql db
2. Modularize terraform code to avoid hardcoding and to enable reusability
3. package the code and deploy via a pipeline or a config management tool
4. Enable authentication on the Graph UI.
5. Make the graph more interactive to allow user to select time range or zoom-in zoom-out.

## Screenshots
![Graph](https://github.com/rokie582/conti-test/blob/master/Screenshot%202020-08-19%20at%2017.17.28.png)
