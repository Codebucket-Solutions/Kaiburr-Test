# Kaiburr-Test

## Notes
### CI.yaml
```
This workflow file needs to adjusted it according to your specific requirements. For example, you may need to update the Docker image name, repository URL, kubernetes namespace, and argocd project.
Additionally, you will need to add the appropriate environment variables (secrets) in your GitHub repository settings. These include DOCKER_USERNAME, DOCKER_PASSWORD, KUBE_TOKEN, KUBE_CLUSTER_NAME, KUBE_NAMESPACE, ARGOCD_PROJECT

You also need to create required Helm charts and place it in chart folder
Also, you will need to have terraform file ready and placed it in root of the project, Also need to create a terraform.tfvars for storing variables for this terraform.
This workflow file will run each of the jobs in the following order

The build job will build the Node.js Docker image, tag it, and push it to Docker Hub.
The deploy job will authenticate with the kubernetes cluster and deploy the application using argocd and Helm.
The provision-mongodb job will use Terraform to provision an EC2 instance and install MongoDB, then it will add the MongoDB endpoints to a Kubernetes configmap and the MongoDB secrets to a Kubernetes secret.
Once this file is in your repository, GitHub Actions will automatically run the workflow whenever code is pushed to the main branch.
```

### values.yml file
```
This values.yaml file contains several settings that can be overridden when installing the chart.

1. `image.repository` and `image.tag` specify the Docker image to be used for the application.
2. `replicaCount` determines how many replicas of the application will be running in the Kubernetes cluster.
3. `service.type` and service.port configure the Kubernetes service that exposes the application to the rest of the cluster.
4. `ingress.enabled` and `ingress.path` configure an ingress for the application if enabled.
5. `mongodb.enabled` determines whether or not to provision MongoDB service for the application.
6. `mongodb.host` and `mongodb.port` specify the `host` and `port` for the MongoDB service.
7. `mongodb.username` and `mongodb.password` provide the credentials for accessing MongoDB.

You can update this file to add or remove any other variables depending on the functionality of your application and to change the default values as per the requirements
Please make sure that the mongodb hostname should match the hostname of the mongodb service created.
```

### terraform.tf file
```
This Terraform file creates the following resources:
- An AWS security group that allows incoming traffic on port 22 (for SSH) and 27017 (for MongoDB) from anywhere.
- An EC2 instance using the specified Amazon Machine Image (AMI) and key pair. This EC2 instance will run the MongoDB
  and it will install MongoDB on the instance using the user_data section.
- A MongoDB RDS instance 

It also includes several output variables:
- `mongodb_endpoints` which outputs the endpoint of the RDS MongoDB instance.
- `mongodb_username` and `mongodb_password` which outputs the MongoDB username and password respectively.


NOTE: It's important to note that this Terraform file is dependent on the variables `aws_region`, `aws_ami`, `aws_key_name`. 
You can either provide values for these variables in a `terraform.tfvars` file or pass them at the time of running terraform apply command.
It's also worth noting that this example assumes that you have already set up your AWS credentials, you can use the AWS provider block to set
up your credentials if you have not done so already. You should also make sure that you're using an appropriate Amazon Machine Image (AMI) for
 your desired operating system, and adjust the MongoDB version and the EC2 instance type as needed.
```
