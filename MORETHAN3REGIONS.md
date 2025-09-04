# Implementing a Multi-Region cluster with more than 3 regions

**It is up to the user to determine if the instance types, storage, etc. is available in the regions being selected.**

I suggest doing a clean clone of the repo everytime this is executed. 

NOTE:  the server running the Multi-Region terraform with more than 3 regions requires a substansial amount of horsepower.  

1.  The scripts to generate the instances and networking require that the scripts can read your `terraform.tfvars` file.   In order to do that, the `python-hcl2` library is required.  

```
pip install python-hcl2
```

2.  Clone the repo
```
git clone https://github.com/nollenr/AWS-Terraform-CRDB-Multi-Region.git

```

3.  Modify the file terraform.tfvars to set the [variables](#Terraform-Variables) for your configuration.   Be sure the following lists contain the same number of entries and that the values correspond between the lists (`vpc_cidr_list[0]`, `aws_region_list[0]`, `aws_instance_keys[0]` are all for the same region):
   - vpc_cidr_list
   - aws_region_list
   - aws_instance_keys 

4.  Generate instances HCL
```
python generate_instances_tf.py
```
Output should look something like:
```
TFVARS:  terraform.tfvars
INPUT:   instances.tf
OUTPUT:  generated_instances.tf
Renamed 'instances.tf' to 'instances.tf.20250903-191944'
✅ Successfully wrote 5 providers and 5 modules to generated_instances.tf
```

5.  Generate networking HCL
```
python3.11 generate_networking.py
```
Output should look something like
```
TFVARS:  terraform.tfvars
INPUT:   networking.tf
OUTPUT:  generated_networking.tf
Renamed 'networking.tf' to 'networking.tf.20250903-192018'
✅ Successfully wrote full-mesh networking configuration for 5 regions to generated_networking.tf
```
6.   Initialize terraform 
```
terraform init
```
7.  Create environment varialbes if necessary
- export TF_VAR_cluster_organization
- export TF_VAR_enterprise_license
- export TF_VAR_db_ui_user_password

8.  Plan and Apply the terraform