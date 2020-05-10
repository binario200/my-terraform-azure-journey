The next Terraform script will create the following resources:

- Create a resource group if it doesn't exist
- Create virtual network
- Create subnet
- Create public IPs
- Create Network Security Group and rule
- Create network interface
- Connect the security group to the network interface
- Create storage account for boot diagnostics
- Create virtual machine

Replace at the line of the file public key, with the path for you public key.
```Terraform
    admin_ssh_key {
        username       = "azureuser"
        public_key     = file("path_to_your_public_key")
    }
```

Run the terraformn command:

```bash
terraform init
terraform plan
terrafomr apply 
```

In order to get the IP address of the new created VM, uses the azure cli command:
```bash 
az vm show --resource-group myResourceGroup --name myVM01 -d --query [publicIps] --o tsv
```

Connect to the VM

```shell
ssh azureuser@<publicIps>
```