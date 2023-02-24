# Terraform EKS modules

The terraform script has been split into reusable modules. Each module is self contained and relies on the variables.tf values being passed in order to create the underlying resources.


## Default workspaces

You need to navigate to an environment i.e `dev` and run `terraform` command for that location. Each environment can have a different set of modules & variables associated with it. For example, a `dev` setup does not need an external `rds` instace but `production` would certainly need to include that module. Each environment acts as the similar to having sperate terraform `workspace` with different states.

Please check the environment variables.tf i.e `environment/dev/variables.tf` for default vaules. You can override or simply change the default values. 

```bash
# cd environment/dev
terraform plan -var 'cluster_name=my-cluster-name'

terraform apply -var 'cluster_name=my-cluster-name'

```

## Usage 

```bash
# from within an environment i.e dev
cd environment/dev

terraform init
terraform plan
terrform apply

# finished with the environment?
# you can run again if you see errors
# S3 bucket content needs to be manually deleted via AWS console
terraform destroy
```

Update your kubeconfig

```bash
aws eks update-kubeconfig --region <region-code> --name <my-cluster>
```


## Directory structure

```
.
└── eks
    ├── README.md
    ├── environment
    │   ├── dev
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── providers.tf
    │   │   ├── terraform.tf
    │   │   └── variables.tf
    │   └── production
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── providers.tf
    │   │   ├── terraform.tf
    │   │   └── variables.tf   
    └── modules
        ├── autoscaler
        │   ├── iam.tf
        │   ├── main.tf
        │   └── variables.tf
        ├── eks
        │   ├── iam.tf
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── hdx
        │   ├── iam.tf
        │   ├── main.tf
        │   └── variables.tf
        ├── rds
        │   ├── main.tf
        │   ├── outputs.tf        
        │   └── variables.tf        
        ├── s3
        │   ├── main.tf
        │   └── variables.tf
        └── vpc
            ├── main.tf
            ├── outputs.tf
            └── variable.tf

```

### TODO
- Add S3 backend for [terraform state](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) with an example
- Document external VPC usage
