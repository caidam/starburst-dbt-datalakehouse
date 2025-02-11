
# ETLT Datalakehouse with dbt and Trino

Simple and (almost) free test implementation of the [Datalakehouse](https://www.databricks.com/fr/glossary/data-lakehouse) and [ETLT](https://www.integrate.io/blog/what-is-etlt/) concepts using Starburst Galaxy, dbt Cloud, AWS, and Terraform.

![dbt trino architecture](/misc/dbt-trino-architecture.png)

## Prerequisites

- A [Starburst Galaxy](https://www.starburst.io/platform/starburst-galaxy/) account or [Trino](https://trino.io/download.html) instance
- A [dbt Cloud](https://www.getdbt.com/product/dbt-cloud) account or [dbt Core](https://www.getdbt.com/product/dbt-core-vs-dbt-cloud) installed locally
- An [AWS](https://aws.amazon.com/?nc2=h_lg) account with the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed locally
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed locally

## Create AWS resources with Terraform

- Dedicated IAM User
- S3 Bucket Policy
- S3 Bucket
- RDS instance security group
- MYSQL RDS instance
- Populate database
- Check resources have been created

## Set up a Starburst Galaxy Cluster

The below steps can also be achieved using a Trino instance, make sure to refer to the relevant documentation.

- Free Cluster
- Catalog creation tutorial
- Connect S3 Catalog
- Connect MYSQL Catalog
- Check data and sample data

> Note that Starburt's free tier has some limitations that may be considered before implementing this, notably regarding available regions for the different cloud providers.

## Set up ETL with dbt Cloud

The below steps can also be achieved using a dbt Core instance, make sure to refer to the relevant documentation.

- Create project
- Connect to your Starburst cluster
- Select main catalog
- Set up sources
- Write your first ETLT models
