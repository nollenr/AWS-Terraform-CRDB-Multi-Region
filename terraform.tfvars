my_ip_address = "98.148.51.154"
aws_region_01 = "us-west-2"
owner = "nollen"
project_name = "demo"
environment = "demo"
crdb_version = "22.2.8"
crdb_nodes = 3
crdb_instance_type = "t3a.micro"
crdb_root_volume_type = "gp3"
crdb_root_volume_size = 8
# To include an HAProxy instance, set 'include_ha_proxy' to yes and supply an 'haproxy_instance_type'
include_ha_proxy = "yes"
haproxy_instance_type = "t3a.micro"
# To include an app node, set 'include_app' to yes and supply an app_instance_type and an admin_user_name.  If you include an app instance, an admin user with cert will automatically be created!
include_app = "yes"
app_instance_type = "t3a.micro"
# this admin user is only created if the include_app is set to yes -- this will include the database user and associated certs installed on the app instance.
admin_user_name = "bob"
# This "key pair" must already exist in the region this is being created!
crdb_instance_key_name = "nollen-cockroach-us-east-1-kp01"

# us-east-1, us-west-2, us-east-2
vpc_cidr_list = ["192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24"]
aws_region_list =  ["us-east-1", "us-west-2", "us-east-2"]
aws_instance_keys = ["nollen-cockroach-us-east-1-kp01", "nollen-cockroach-us-west-2-kp01", "nollen-cockroach-us-east-2-kp01"]

# us-east-1, ap-southeast-1, eu-central-1
# vpc_cidr_list = ["192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24"]
# aws_region_list =  ["us-east-1", "ap-southeast-1", "eu-central-1"]
# aws_instance_keys = ["nollen-cockroach-us-east-1-kp01", "nollen-cockroach-ap-southeast-1-kp01", "nollen-cockroach-eu-central-1-kp01"]
