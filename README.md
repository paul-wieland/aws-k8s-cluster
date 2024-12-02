# K8s cluster on AWS

### Cloud Infrastructure

In the ```infrastructure``` folder are all resources specified to get the following setup running in AWS.
It includes a ```VPC```, ```Public subnet```, ```Private subnet```, ```Internet Gateway (IGW)```, ```NAT```, ```Bastion Host``` in the Public subnet and 
three machines in the Private subnet.
The setup follow best practices, the nodes of the k8s cluster will be created in the private subnet only.
The nodes can connect to the internet via a NAT which is placed in the Public subnet and connected to the IGW.
The Bastion Host allows to connect to the k8s nodes in a secure way via ssh, without exposing the k8s to the internet.
This is important, as the k8s nodes need to open several ports to make k8s running.

*Note:* Not all resources (e.g. Route Tables, Key Pair, etc.) are not showed in this architecture

<p align="center">
<img src="./assets/aws-k8s-cluster.drawio.png" alt=""/>
</p>

## Install k8s cluster

### 1. Generate ssh key pair

Create a new ssh keypair in ```./keys```  named ```ssh```.  Note that 
the Ansible setup expects the key with that name and location.

```angular2html
ssh-keygen -t rsa -b 2048 -f ./keys/ssh_key
```

### 2. Create infrastructure

Create an AWS user for the Terraform setup. Go to ```IAM > Users > Create User``` and crate a new user with
```AdministratorAccess``` permissions. 


<p align="center">
<img src="./assets/aws-terraform-user-permission.png" alt=""/>
</p>

Then, go to ```./infrastructure/main.tf``` and replace ```access_key``` and ```secret_key``` from your new account.

```terraform
provider "aws" {
  region     = var.region
  access_key = "XXX"
  secret_key = "XXX"
}
```

Once this is done, you can create the infrastructure:

```terraform
terrafrom apply
```

After the resources have been successfully created the inventory file can be found in ```./generated/inventory.ini```.  

**Note: You can further configure the infrastructure setup in ```variables.tf``` (e.g. change the region)**

### 3. Install k8s cluster with Ansible

**Control Plane**

```
ansible-playbook -i ../generated/inventory.ini control-plane.yml
```

**Note: The setup for the control plane will output ```./ansible/kubernetes_join_command``` for the worker nodes to join**

**Worker**

```
ansible-playbook -i ../generated/inventory.ini worker.yml
```


## Manually connect to EC2 instances


***Bastion host***
```angular2html
ssh -i ssh_key ec2-user@<BASTION_HOST_PUBLIC_IP>
```

***Private host via Bastion host***
```angular2html
ssh -i ssh_key -o ProxyCommand="ssh -i ssh_key -W %h:%p ec2-user@<BASTION_HOST_PUBLIC_IP>" ec2-user@<PRIVATE_HOST_PRIVATE_IP>
```

***Note: you can find the IP address of the hosts either in ```./generated/invetory.ini``` or simply look it up in the AWS console***


#### Links

- [Terraform Icons](https://github.com/kubernetes/community/tree/master/icons)
- [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/)