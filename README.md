# Smart Home Network of Microservices

## Introduction

This project creates a hosted network of microservices that mocks a smart home network which includes a central status service, a lighting service, and a heating service. The lighting service allows for the turning on and off light switches in the home. The heating service changes the temperature of each room in a home. The central status service provides the status of the heating and lighting services.

This project was created using AWS resources and Terraform. 
AWS - VPC, EC2, DynamoDB, Terraform
Terraform is a popular Infrastructure as Code software tool. Terraform eliminates manual configuration errors and easily duplicates environments for different purposes, such as development, testing and production. 


<!-- Insomnia to perform HTTP requests
Virtual Studio Code Editor to construct the Terraform code -->

Brief overview of challenges faced
- creating ami images and having to put new dns host names into env.local file of status server for it to run. Considerations to improve on project is to create an internal load balancer which will pass traffic to the server so it doesn't need to update it's .env.local file if instances change


<!-- What do you get by running this code? What can you tangiably use? What the application can do and how it does it?

This code will create a production ready network with microservices that will use a dynamodb database tables to store 

Add some challenges and how you solved them (emphasise problem solving skills)
What did you learn?
What was the motivation for this project? -->

## Contents

## Setup Infrastructure
<!-- How to use this to set up the same infrastructure in a different environment (dev vs production) -->

## Usage

### Directories and file structure


The infrastructure has been split into multiple directories which includes modules consisting of each logical component. Each module directory is further explained below. 


The provider.tf file contains the terraform and provider blocks.
The main.tf file contains the references to each module and passes through the variables that are used from the variables.tf file or other modules.
The variables.tf file contains the definition of the variables used throughout the project, which includes the datatype needed and a description of the variables use case.
The variables.tfvars file contains the values of the variables used throughout the project.
The output.tf file contains any output resources. Although this file and some other outputs.tf files used in modules do not contain any outputs, output.tf files have been created throughout for development environments for use when outputs are required. An example use case is to provide the DNS host names for each server to be used in making HTTP requests. 
(maybe add this into the outputs)

(add picture of the file structure)
In each explain using the arguments/variables and attributes/outputs

#### Modules
##### Virtual Private Cloud (VPC) Module
The VPC Module creates a Virtual Private Cloud where all resources in the project will be hosted on.

**variables.tf**  contains the relevant values that need to be utilisied to create the vpc dynamically. 
*vpc_name - used to create the name of the VPC to easily distinguish it from other VPCs 
*vpc_cidr_range used to provide a block of IP addresses for use within the VPC
*public_subnets and private_subnets are CIDR ranges which resources in each subnet are able to use 
*availability_zones which are AWS isolated locations inside of regions. 

**main.tf** contains the resource blocks for creating the VPC and related infrastructure. 
*VPC is created with dns host names and support enabled to provide users with a human readable URL when utilising the servers. 
*Public and private subnets are created using the VPC id to connect to the VPC, relevant CIDR blocks to separate them, three availability zones to ensure high availability of services if a zone becomes compromised. The difference between the public and private subnets is the attribute "map_public_ip_on_launch", is set to true for public subnets to ensure that the resources inside them are able to connect to the internet. To provide the dynamic creation of three public and three private subnets a count loop is used which loops through the provided availability zones and public and private CIDR ranges ensuring each are created with separate variable values. Another use of the count loop is to dynamically name each resource in the names tag attribute. 
*Route table is created and associated to each public subnet using a count loop and a route table association. *Internet gateway is created to allow for the public subnets to access the internet through connecting the route table and internet gateway together using a route resource. 

**output.tf** contains the outputs from the resources, that are needed to set up resources in other modules. 
*vpc_id is outputted to be used in creating other resources to ensure they are all deployed inside the same VPC. 
*public_subnets_ids are outputted to be passed to the servers, loadbalancing and autoscaling modules to ensure these resources are connected to the correct subnets and can connect to the internet.

##### Security Module
The Security Module is dedicated to establishing security measures within the VPC. The primary focus is on creating security groups and rules that dictate the traffic flow to and from the services running in the VPC. This maintains a secure network environment for the smart home project.

**variables.tf**
*vpc_id is used to ensure  all security groups are associated with the correct VPC

**local.tf**
*ipv4_all_cidr_blocks and ipv6_all_cidr_blocks: These locals define CIDR blocks for IPv4 and IPv6, and are used in security group rules to specify the range of IP addresses allowed for traffic.

**data.tf**
*myipv4address and myipv6address: These data sources fetch the public IPv4 and IPv6 addresses of the user, which are used in the SSH security group rule to restrict SSH access to the user's IP address only.

**main.tf** 
Creates four security groups to be used in establishing secure ingress and egress traffic.

*allow_http: Permits ingress and egress HTTP traffic (port 80) from all external sources.
*allow_https: Allows ingress and egress HTTPS traffic (port 443) from all external sources.
*allow_ssh: Configured to allow SSH access (port 22) specifically from the user's own IP address.
*allow_port_3000: Designed for the lighting application, it allows traffic on port 3000.

Creates rules for ingress and egress traffic that correspond with each security group 
*For allow_http, allow_https, and allow_port_3000, the rules permit traffic from all IPv4 and IPv6 addresses.
*For allow_ssh, the ingress rule is more restrictive, allowing SSH only from the user's IP address for enhanced security.

**outputs.tf**
*security_groups_ids: Outputs the IDs of the created security groups. These IDs are used in the creation of servers, autoscaling groups, and load balancers in other modules, ensuring that the correct security groups are applied to each resource.


##### Servers Module
The Servers Module is integral to the Smart Home Network project, focusing on deploying servers within the  VPC. This module is responsible for provisioning EC2 instances that host the lighting, heating and status services in the smart home project. The use of variables and dynamic counts ensures flexibility and scalability, allowing easy adjustments to the infrastructure based on future needs or changes. 

**variables.tf**
*security_groups_ids: Holds the IDs of security groups that will be attached to the EC2 instances for network security.
*instance_type: Specifies the type of EC2 instance (e.g., t2.micro, t2.large) to be used for the servers, which determine the computing capacity needed.
*public_subnet_ids: Contains the IDs of the public subnets where the EC2 instances will be placed, ensuring they are in the correct network segments and can connect to the internet.
*service_names: A list of names for the servers in order to easily identify them.
*ami_ids: Lists the Amazon Machine Image (AMI) IDs for the instances, defining the pre-configured virtual servers where the services application code has been installed with npm and pm2.
*key_name: Name of the security key used for SSH access to the EC2 instances.

**main.tf**
Inside the main.tf file, the aws_instance resource creates the EC2 instances to be used for the servers and establishes the configurations needed.
*count: Utilises the length of ami_ids to determine the number of instances to be created.
*ami: Specifies which AMI to use for each instance, based on ami_ids.
*instance_type: Determines the computing power of the instances.
*subnet_id: Ensures each instance is deployed in the correct public subnet.
*associate_public_ip_address: Set to true to assign a public IP address to each instance, allowing them to be accessed over the internet.
*vpc_security_group_ids: Attaches the security groups to the instances for network traffic control.
*key_name: Assigns the specified key for SSH access.
*tags: Helps in identifying each server by its service name.

**outputs.tf**
*server_instance_ids: Outputs the IDs of the created EC2 instances. These IDs are used in other modules for managing, monitoring, or linking other resources to these servers.

##### Database Module
The Database Module sets up and manages the database infrastructure using Amazon DynamoDB, where the data handling for the smart home project occurs. DynamoDB is a fully managed NoSQL database service that supports key-value data structures, making it ideal for flexible, scalable, and fast data storage and retrieval.

**variable.tf**
*database_tables_names: This variable contains a list of names for the DynamoDB tables to be created. These names identify each table's purpose and links them to the heating and lighting services they are used in.

**main.tf**
Inside the main.tf file, the aws_dynamodb_table resource creates the DynamoDB tables used to store and retrieve data related to the heating and lighting servers.
*count: Uses the length of database_tables_names to determine the number of tables to create.
*name: Sets the name for each DynamoDB table, drawn from database_tables_names.
*billing_mode: Set to "PAY_PER_REQUEST" which is a flexible billing option allowing payment for the capacity used rather than provisioning capacity ahead of time. 
*hash_key: Configured to use "id" as the primary key for the tables. 
*attribute: Defines the attributes for the DynamoDB tables, with the attribute "id" being created with the type "N" (number).
*tags: Dynamically tags each DynamoDB table with a name linked to the server utilising it.

**outputs.tf**
Currently, this file is empty. It can be used to output resources such as the table names or ARNs (Amazon Resource Names) for integration with other AWS services or for management purposes if future service additions are added to the smart home project. 

##### Load Balancer Module
The Load Balancer Module in the Smart Home Network project sets up an Application Load Balancer (ALB) to manage and distribute incoming network traffic across multiple servers, ensuring high availability and fault tolerance for the smart home services.

**variables.tf**
*vpc_id: Identifies the VPC in which the load balancer is to be created.
*server_instance_ids: Lists the instance IDs of the servers that will be attached to the target groups of the load balancer.
*security_groups_ids: Contains the IDs of security groups to be associated with the load balancer for traffic control.
*public_subnet_ids: Specifies the public subnet IDs where the load balancer will be located.
*service_names: Names of the services for which the target groups are created.
*target_group_paths: Defines the paths for the servers, which are used to route traffic in the load balancer target groups.

**main.tf**
The aws_lb resource creates the application load balancer.
*name: Used to identify the load balancer.
*load_balancer_type: Specifies the type of load balancer to be created, in this case application.
*internal: Specifies that the load balancer is internet-facing.
*security_groups: Attaches security groups for controlling the traffic.
*subnets: Associates the load balancer with public subnets.

**outputs.tf**
*load_balancer_target_group_arns: Outputs the ARNs (Amazon Resource Names) of the target groups. These ARNs are outputted to be used in associating the load balancer with the autoscaling groups in the autoscaling module.

##### Autoscaling Module
The Autoscaling Module creates an autoscaling group in the Smart Home project, which automatically adjusts the number of EC2 instances based on demand. This provides a cost-effective solution by not creating too many instances that may not be utilised but giving the ability to create more resources when demand increases.

**variables.tf**
*service_names: Lists the names of services for which the autoscaling groups are created.
*public_subnet_ids: Contains the IDs of the public subnets where the EC2 instances will be launched.
*ami_ids: Specifies the Amazon Machine Image (AMI) IDs used to create the instances in the autoscaling group.
*key_name: Indicates the name of the SSH key used for instance access.
*security_groups_ids: Holds the IDs of security groups attached to each instance for network security.
*instance_type: Defines the type of EC2 instance to be used, determining the computing resources available.
*load_balancer_target_group_arns: Contains the ARNs of the target groups associated with the load balancer, used for routing traffic to the EC2 instances.
*min_size, max_size, desired_capacity: Defines the minimum, maximum, and desired number of instances in the autoscaling group.

**main.tf**
The aws_launch_template resource creates a launch template for each service.
*name: Used to identify the instance.
*image_id: provides the image Amazon Machine Image (AMI) used in creating the instance. 
*instance_type: Determines the computing power of the instances.
*key_name: Assigns the specified key for SSH access.
vpc_security_group_ids: Specifies the security groups for the instances.
tag_specifications: Dynamically adds a name tag to identify the instance.

The aws_autoscaling_group resource defines the autoscaling groups.
*name: Used to identify the autoscaling group.
*min_size, max_size, desired_capacity: Sets up the scaling parameters for the group.
*vpc_zone_identifier: Specifies the public subnets in which instances are launched.
*launch_template: Associates the launch template with the autoscaling group.
*target_group_arns: Links the autoscaling group to the appropriate target group in the load balancer.
*tag: Configures tagging for the instances, with propagate_at_launch set to true to apply the tags to all instances launched in the group.

**outputs.tf**
Currently, this file is empty. It can be used to output resources such as the autoscaling group ids or launch template ids for integration with other AWS services or for management purposes if future service additions are added to the smart home project. 


## Troubleshooting

Use the browser, curl commands or tools such as insomnia to check the API calls to the Dynamodb database are functioning correctly. 
If no requests to the server are working, use the following steps:
Check the health status of the server 

Check the health of the load balancer, using the load balancers dns host name, followed by the API URL:

If GET requests to the server are working, but POST requests are not working, use the following steps:

Check the health status of the server 
Check the health of the load balancer
Ensure the JSON object is formatted correctly, using strings inside of an object.
<!-- (add curl commands)
(add insomnia) -->
Ensure the input matches what the API is expecting.

Check env.local files are correct
<!-- Lighting server should contain = 
Heating server should contain = 
Status server should contain =  -->

Ensure there are no spaces or special characters, as this can cause unexpected results. 

If lighting and heating are functioning correctly, but the status server is not. Check if the server .env.local file has the correct DNS host names. If the heating or lighting server have been destroyed and new instances made, they will have different dns host names.








