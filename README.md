# Infrastructure as code for OpenStack deployment of ONAP

## Build your infrastructure with Terragrunt(Terraform) for ONAP

Preparing ONAP for deployment requires Openstack VMs with Kubernetes and helm installed. 
Building underlying infrastructure for ONAP with Openstack GUI or command-line interfaces is not only time-consuming but also prone to mistakes.
By providing Infrastructure as Code for deploying ONAP, building and managing the underlying infrastructure become simpler and easier.
This [link](https://docs.onap.org/en/casablanca/submodules/oom.git/docs/oom_setup_kubernetes_rancher.html#onap-on-kubernetes-with-rancher) shows how to set up the underlying infrastructure with Openstack GUI and Command line tool.

This Terragrunt(Terraform) code provides the same infrastructure as you would create through the process outlined in the link above.


## Directory structure
```
openlab             # Terragrunt scripts to feed configuration into the Terraform modules 
 └ RegionOne        # For multi regions. e.g, us-east-1
   └ stage          # Environment specific configuration. e.g, QA/Stage/Prod
     └ resource
```

Infrastrucuture is organized hierarchically in folders.
The root level folder represents an account for clouds such as Openstack or AWS.
The second and third levels represent the region in a cloud and environment under the region respectively.

### Preparation
1. You need a cloud storage bucket to store an intermediate state for your infrastructure. The remote state enables your team to work together as well.  We tested this code using a Google Storage bucket. You can choose AWS S3 as well as others.


2. Openstack is the primary target for this code. We tested this code onto Openstack v3.8 (Ocata) 
We deployed VMs and K8s with the scripts and after that we deployed ONAP Frankfurt version with OOM.

### Usage
#### Set up environment variables for your target cloud.

1.a You need to export cloud storage credential.
For instance, if you use Google Storage bucket, you can download the credentials from Google UI or the command-line tool.
Go to Google Cloud project's `IAM & Admin` menu and choose the service account associated with the storage.
You can export the credential as a JSON formatted file.  Then
`export GOOGLE_APPLICATION_CREDENTIALS=/path/to/credential-file`.
Please, refer to the following [link](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).

Second, you need to export Openstack credentials. You can use the openstack.rc file downloaded from your Openstack project.
Please, refer to the following [link](https://docs.openstack.org/ocata/user-guide/common/cli-set-environment-variables-using-openstack-rc.html) for details.

Finally, check all the environmental variables are set with the `env` command.
For example,
``
GOOGLE_APPLICATION_CREDENTIALS=/path/to/google_credential
password=OpenstackPassowrd
user_name=OpenstackUser
auth_url=http://x.x.x.x:..
project_id=12345667
``

#### Fill in files
 - `account.hcl`: Top-level configuration for a cloud account.
 - `region.hcl`: The second level configuration for a region within the cloud
 - `env.hcl`: The third level configuration for an environment within the region
 - `terragrunt.hcl`: files under the compute directory. Since Kubernetes deployment needs 2 types of nodes (control and worker) plus 1 NFS cluster, these files under the compute directory contain the configuration for Kubernentes and NFS nodes 

####  Building all modules for an environment
Move to an environmental level folder, e.g stage.
Then run `terragrunt apply-all` followed by `terraform init`

Terraform version 0.13 is required.

https://github.com/gruntwork-io/terragrunt-infrastructure-live-example#deploying-all-modules-in-a-region

####  Updating infrastructure version
Infrastructure may evolve. You can use existing infrastructure as it is or updating the infrastructure to meet a new requirement.
To deploy a different version of infrastructure, you can change a tag of `source` module version.
Please, refer to the below document.
If you like to test a new module (Terraform code) with Terragrunt, you just need to change the source attribute within Terrafrom block in each terragurnt.hcl file.
[link](https://www.terraform.io/docs/modules/sources.html#generic-git-repository)

####  Using Kubernetes and helm

Please, refer to [link](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example#example-infrastructure-live-for-terragrunt)

#### Obtaining your KUBECONFIG
Finally, You need to export Kubernenetes credentials.
This credential is used when Helm service account is created. 
For example, `export KUBECONFIG=/path/to/kube_config_cluster.yaml`
In default, `kube_config_cluster.yaml` will be created under `path/to/openlab/RegionOne/stage` directory once you run `terragrunt apply-all`

## Google Cloud Backend for Terraform
To use the Google Cloud Storage backend for Terraform -- it stores state and manages locking -- you'll need to install the Google Cloud SDK.  Follow the instructions here https://cloud.google.com/sdk.
You can do this task with Google Cloud's Web.

1. Create a service account
gcloud iam service-accounts create `service-account-name` 

2. Binding the service account with a role 
gcloud projects add-iam-policy-binding `project id` --member "serviceAccount:service-account-name-above@project-id.iam.gserviceaccount.com" --role "roles/proper-role-such-as-storage-user"

3. To create a key for the service account created above
gcloud iam service-accounts keys create account.json --iam-account `service-account-name-above@project-id.iam.gserviceaccount.com

4. Create a storage bucket
gsutil mb -p project-id gs://storage-bucket-name

## Secrets
How to hide your secret and provide it via a key management tool. Please, refer to the link below.
Refer to https://nderraugh.github.io/
