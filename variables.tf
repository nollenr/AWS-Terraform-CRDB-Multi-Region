# ----------------------------------------
# Cluster Enterprise License Keys
# ---------------------------------------- 
# Be sure to do the following in your environment if you plan on installing the license keys
  #   export TF_VAR_cluster_organization='your cluster organization'
  #   export TF_VAR_enterprise_license='your enterprise license'
  variable "cluster_organization" { 
    type = string  
    default = "" 
  }
  variable "enterprise_license"   { 
    type = string  
    default = "" 
  }

# ----------------------------------------
# Regions
# ----------------------------------------
    variable "aws_region_01" {
      description = "AWS region"
      type        = string
      default     = "us-east-1"
    }

    variable "aws_region_list" {
      description = "list of the AWS regions for the crdb cluster"
      type = list
      default = ["us-east-1", "us-west-2", "us-east-2"]
    }

    variable "aws_instance_keys" {
      description = "The instance keys - they should match the regions and the order in the aws_region_list.  These will be used when the ec2 instances are created in each region"
      type = list
      default = ["nollen-cockroach-us-east-1-kp01", "nollen-cockroach-us-west-2-kp01", "nollen-cockroach-us-east-2-kp01"]
    }

# ----------------------------------------
# TAGS
# ----------------------------------------
    # Required tags
    variable "project_name" {
      description = "Name of the project."
      type        = string
      default     = "terraform-test"
    }

    variable "environment" {
      description = "Name of the environment."
      type        = string
      default     = "dev"
    }

    variable "owner" {
      description = "Owner of the infrastructure"
      type        = string
      default     = ""
    }

    # Optional tags
    variable "resource_tags" {
      description = "Tags to set for all resources"
      type        = map(string)
      default     = {}
    }


# ----------------------------------------
# CIDR
# ----------------------------------------
    variable "vpc_cidr" {
      description = "CIDR block for the VPC"
      type        = string
      default     = "192.168.4.0/24"
    }

    variable "vpc_cidr_list" {
      type = list
      default = ["192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24"]
    }

# ----------------------------------------
# My IP Address
# This is used in the creation of the security group
# and will allow access to the ec2-instances on ports
# 22 (ssh), 26257 (database), 8080 (for observability)
# and 3389 (rdp)
# ----------------------------------------
    variable "my_ip_address" {
      description = "User IP address for access to the ec2 instances."
      type        = string
      default     = "0.0.0.0"
    }

# ----------------------------------------
# CRDB Instance Specifications
# ----------------------------------------
    variable "crdb_nodes" {
      description = "Number of crdb nodes.  This should be a multiple of 3.  Each node is an AWS Instance"
      type        = number
      default     = 3
      validation {
        condition = var.crdb_nodes%3 == 0
        error_message = "The variable 'crdb_nodes' must be a multiple of 3"
      }
    }

    variable "crdb_instance_type" {
      description = "The AWS instance type for the crdb instances."
      type        = string
      default     = "m6i.large"
    }

    variable "crdb_arm_release" {
      description = "Do you want to use the ARM version of CRDB?  There are implications on the instances available for the installation.  You must choose the correct instance type or this will fail."
      type        = string
      default     = "yes"
      validation {
        condition = contains(["yes", "no"], var.crdb_arm_release)
        error_message = "Valid value for variable 'arm' is : 'yes' or 'no'"        
      } 
    }

    variable "crdb_enable_spot_instances" {
      description = "Do you want to use SPOT instances?  There are implications on the instances available for the installation.  You must choose the correct instance type or this will fail."
      type        = string
      default     = "no"
      validation {
        condition = contains(["yes", "no"], var.crdb_enable_spot_instances)
        error_message = "Valid value for variable 'spot instances' is : 'yes' or 'no'"        
      } 
    }

    variable "crdb_root_volume_type" {
      description = "EBS Root Volume Type"
      type        = string
      default     = "gp2"
      validation {
        condition = contains(["gp2", "gp3"], var.crdb_root_volume_type)
        error_message = "Valid values for variable crdb_root_volume_type is one of the following: 'gp2', 'gp3'"
      }
    }

    variable "crdb_root_volume_size" {
      description = "EBS Root Volume Size"
      type        = number
      default     = 8
    }

    variable "crdb_store_volume_type" {
      description = "EBS Root Volume Type"
      type        = string
      default     = "gp2"
      validation {
        condition = contains(["gp2", "gp3"], var.crdb_store_volume_type)
        error_message = "Valid values for variable crdb_root_volume_type is one of the following: 'gp2', 'gp3'"
      }
    }

    variable "crdb_store_volume_size" {
      description = "EBS Root Volume Size"
      type        = number
      default     = 8
    }

    variable "crdb_instance_key_name" {
      description = "The key name to use for the crdb instance -- this key must already exist"
      type        = string
      nullable    = false
    }

    variable "crdb_version" {
      description = "CockroachDB Version"
      type        = string
      default     = "23.1.10"
    }

    variable "run_init" {
      description = "'yes' or 'no' to include an HAProxy Instance"
      type        = string
      default     = "yes"
      validation {
        condition = contains(["yes", "no"], var.run_init)
        error_message = "Valid value for variable 'include_ha_proxy' is : 'yes' or 'no'"
      }
    }

    variable "create_admin_user" {
      description = "'yes' or 'no' to include an HAProxy Instance"
      type        = string
      default     = "yes"
      validation {
        condition = contains(["yes", "no"], var.create_admin_user)
        error_message = "Valid value for variable 'include_ha_proxy' is : 'yes' or 'no'"
      }
    }

    variable "admin_user_name"{
      description = "An admin with this username will be created if 'create_admin_user=yes'"
      type        = string
      default     = ""
    }

# ----------------------------------------
# HA Proxy Instance Specifications
# ----------------------------------------
    variable "include_ha_proxy" {
      description = "'yes' or 'no' to include an HAProxy Instance"
      type        = string
      default     = "yes"
      validation {
        condition = contains(["yes", "no"], var.include_ha_proxy)
        error_message = "Valid value for variable 'include_ha_proxy' is : 'yes' or 'no'"
      }
    }

    variable "haproxy_instance_type" {
      description = "HA Proxy Instance Type"
      type        = string
      default     = "t3a.small"
    }

# ----------------------------------------
# APP Instance Specifications
# ----------------------------------------
    variable "include_app" {
      description = "'yes' or 'no' to include an HAProxy Instance"
      type        = string
      default     = "yes"
      validation {
        condition = contains(["yes", "no"], var.include_app)
        error_message = "Valid value for variable 'include_app' is : 'yes' or 'no'"
      }
    }

    variable "app_instance_type" {
      description = "App Instance Type"
      type        = string
      default     = "t3a.micro"
    }

# ----------------------------------------
# TLS Vars -- Leave blank to have then generated
# ----------------------------------------
    variable "tls_private_key" {
      description = "TLS Private Key PEM"
      type        = string
      default     = ""
    }

    variable "tls_public_key" {
      description = "TLS Public Key PEM"
      type        = string
      default     = ""
    }

    variable "tls_cert" {
      description = "TLS Cert PEM"
      type        = string
      default     = ""
    }
