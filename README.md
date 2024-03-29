# AWS Infrastructure

The terraform code present in this repo will create the infrastructure necessary to run the AST single-tenant solution.

# S3 Backend configuration

[Terraform documentation](https://www.terraform.io/language/settings/backends/s3)

 - To enable remote state storage with S3, the first step is to create an S3 bucket.

The terraform state file will be saved in an S3 bucket. To be sure that the state will be saved in the desired location, please change the file `s3_backend_configuration.conf` present in both directories (infrastructure and kubernetes-config).

The file structure should follow this schema
```
bucket="<BUCKET_NAME>"
region="<BUCKET_REGION>"
key="<S3_KEY>/terraform.tfstate"
```

For example:
```
bucket="terraform-state-bucket"
region="eu-west-1"
key="infra/terraform.tfstate"
```


## Using Makefile configuration
When running the command `make init` on the desired directory it will use this file to pass the parameters to the terraform backend configuration.

## Using terraform command line
`terraform init -backend-config=s3_backend_configuration.conf`

or you can use the full command:

`terraform init -backend-config=bucket=BUCKET_NAME -backend-config=key=S3_KEY -backend-config=region=AWS_REGION`

# Instalation order

- The first terraform module that needs to be installed is `infrastructure`  only after the instalation is complete you should move to the second one.


```
cd infrastructure
make plan
make apply
```


- When the infrastructure is ready, apply the module `kubernetes-config`.

```
cd kubernetes-config
make plan
make apply
```

Please, take a look on the `example.auto.tfvars` file to see the parameters that you need to inform.



# TF Destroy


If you already installed the CxOne solution using Kots, before running `make destroy` it is recommended to uninstall the following HELM chart:
- ast (helm uninstall ast -n ast)

This is recommended to avoid leaving the load balancer created by the traefik service behind.

## Destroy the module kubernetes-config

```
cd kubernetes-config
make destroy
```

## Destroy the module infrastructure

```
cd infrastructure
make destroy
```