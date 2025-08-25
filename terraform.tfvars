my_ip_address = "98.148.51.154"
owner = "nollen"
project_name = "demo"

crdb_nodes = 3                       # nodes per region
crdb_instance_type = "t4g.medium"
crdb_store_volume_type = "gp3"
crdb_store_volume_size = 8
# iops and throughput are only used for gp3 volumes
# ratio of IOPS to volume size cannot be greater than 500
# ration of throughput to volume size cannot be greater than 25
# crdb_store_volume_iops = 3000
# crdb_store_volume_throughput = 125
crdb_version = "25.2.4"
crdb_arm_release = "yes"
crdb_enable_spot_instances = "no"
crdb_wal_failover = "yes"
create_db_ui_user = "no"  # <------------ setting this to yes, requires you to set an environment variable prior to running the HCL.  See the NOTE below.
db_ui_user_name = "bob"
# **********************************************************
# NOTE:  If you want to have a DB UI user created, define
#        the shell varaible "TF_VAR_db_ui_user_password"
#        prior to running this script!    The value will
#        automatically be picked up by this HCL and applied
# **********************************************************
# db_ui_user_password = ""

# To include an HAProxy instance, set 'include_ha_proxy' to yes and supply an 'haproxy_instance_type'
include_ha_proxy = "yes"
haproxy_instance_type = "t3a.micro"
# To include an app node, set 'include_app' to yes and supply an app_instance_type and an admin_user_name.  If you include an app instance, an admin user with cert will automatically be created!
include_app = "yes"
app_instance_type = "t3a.micro"
# this admin user is only created if the include_app is set to yes -- this will include the database user and associated certs installed on the app instance.
admin_user_name = "ron"

# us-east-1, us-west-2, us-east-2
vpc_cidr_list = ["192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24"]
aws_region_list =  ["us-east-2", "us-west-2", "us-east-1"]
aws_instance_keys = ["nollen-cockroach-revenue-us-east-2-kp01", "nollen-cockroach-revenue-us-west-2-kp01", "nollen-cockroach-revenue-us-east-1-kp01"]

# us-east-2, ap-southeast-1, eu-central-1
# vpc_cidr_list = ["192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24"]
# aws_region_list =  ["us-east-2", "ap-southeast-1", "ap-northeast-2"]
# aws_instance_keys = ["nollen-cockroach-us-east-2-kp01", "nollen-cockroach-ap-southeast-1-kp01", "nollen-cockroach-ap-northeast-2-kp01"]
