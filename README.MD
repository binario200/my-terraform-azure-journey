# Managing Azure Infrastructure with Terraform 

Here I will share my learnings using Terraform at Microsoft Azure. 

After [installing Terraform](https://www.terraform.io/downloads.html)  the next step is configuring the Terraform access to Azure (you will need [azure subscription](https://azure.microsoft.com/free/?ref=microsoft.com&utm_source=microsoft.com&utm_medium=docs&utm_campaign=visualstudio))

Also you I will be using Azure CLI command, you can fins how to install the [Azure CLI here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)


## Configure Terraform access to Azure
To enable Terraform to provision resources into Azure, create an Azure AD service principal. The service principal grants your Terraform scripts to provision resources in your Azure subscription.

Having installed your Azure CLI and subscription, loging to you Azure account from your terminal:

```bash
az login
```

If you find connecting issues with your corporate proxy try any of these [solutions](https://github.com/Azure/azure-cli/blob/dev/doc/use_cli_effectively.md#working-behind-a-proxy) or [this] (https://blog.jhnr.ch/2017/09/24/use-azure-cli-with-corporate-proxy-server/)

Query the information of you azure subscription
```bash
az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}"
```

Set your subscription for you azure cli session 
```bash
export SUBSCRIPTION_ID=$(az account list --query "[].{subscriptionId:id}")

az account set --subscription="${SUBSCRIPTION_ID}"
```

Now create the Azure AD service principal
```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
```

Your appId, password, sp_name, and tenant are returned. Make a note of the appId and password.

## Configure Terraform environment variables
To configure Terraform to use your Azure AD service principal, set the following environment variables, which are then used by the Azure Terraform modules.

```bash
export ARM_SUBSCRIPTION_ID=your_subscription_id
export ARM_CLIENT_ID=your_appId
export ARM_CLIENT_SECRET=your_password
export ARM_TENANT_ID=your_tenant_id
```

## Running a test
Continuing at your azure cli session, use the test.tf file and run the Terraform commands:
```

```
