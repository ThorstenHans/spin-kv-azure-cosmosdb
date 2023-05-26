# Use Azure Cosmos DB as key-value store for Fermyon Spin

This repository contains a sample application that demonstrates how to use Azure Cosmos DB as key-value store for Fermyon Spin.

Consider reading the corresponding article at [https://thorsten-hans.com/azure-cosmos-db-as-key-value-store-for-fermyon-spin/](https://thorsten-hans.com/azure-cosmos-db-as-key-value-store-for-fermyon-spin/) for a detailed walk-through.

## Provision the infrastructure

The `infra` folder contains a Terraform project which you can use to provision the required infrastructure in Azure. Once you've cloned the repo and installed Terraform on your machine, you can either use a Service Principal for authentication or re-use existing auth tokens from Azure CLI `az`.

To provision the infrastructure, invoke `terraform apply -auto-approve`

## Configure the Spin App

You must update `/app/rt-config.toml` with the values provided as output from Terraform. To read the sensitive `key` output, use `terraform output -raw key`

## Run the Spin application

You can run the Spin app using the `Makefile` located in the root of this repository. Simply invoke `make run`

## Testing

You can use `curl` to test the application:

```bash
# store some data in the key-value store
curl -iX POST --data 'hello' http://localhost:3000/test

# retrieve data from the key-value store
curl -iX GET http://localhost:3000/test

hello
```
