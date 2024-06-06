# CI/CD 

This is a project that seeks to provide a continuos integration and deployment solution for a full-stack web application, as well as a AWS architecture defined in terraform


## LendARead's Goal
![Lend a read logo](LendARead2-AWS/LendARead2/frontend/public/static/logo-claro.png)

The goal of the web application is to create a community of readers, where all of them can upload their books and request loans from each other. The aim is to allow readers to access books that would not normally be easily accessible.

For example, let's imagine the user Marco, who enjoys reading philosophy in multiple languages. Thanks to other readers with German heritage (for example), he can borrow a philosophy book from a German author that he could not have read by going to a library in Argentina.


## Architecture

The LendARead architecture is deployed through terraform as part of a 3-tier architecture. In addition, the current project builds three versions: dev, qa, prod thus providing a devops approach to the deployment of LendARead.

![Cloud Diagram](LendARead2-AWS/cloud.png)

The diagram shows the three different versions of the same architecture design. Due to time constraints the actual deployments of dev and qa do not fully optimize deployments as per the diagram (it's more like two more prod enviroments
but without database and task replication).
## CI/CD Setup

To begin the pipeline one should first initialize the s3 bucket and dynamo table to hold both the terraform state as well as a lock to prevent incosistencies in the terraform state stored in the s3. To initialize the architecture one should push the tag `init`

```bash
git tag init                                                                                          
git push origin init
```

This will trigger a Github action that will create the s3 bucket and dynamo table. After this is complete one can push to the main branch, this will run the `terraform init` and `terraform apply` using the state defined in the last step. Whatever changes are done to the application, or the infraestructure itself, will be updated in the deployment. The key here is that because the state is stored in a s3 only the changes to the current architecture will be made, if nothing of the infraestructure changed then only the docker image will be updated. 

## CI/CD Environments:
To run the demo, the repository needs 3 environments to run:
- dev
- qa
- prod
Configure each environment with the corresponding approval permits

## CI/CD Flow
To trigger a workflow for the deployment, the creation of a Release with a new tag is necessary:
- The tag must follow the regex: `v[0-9]+.[0-9]+.[0-9]+`
- A job to extract the value of the newly created tag will run
- After that, a job that will check all the tests in the application will run. If it runs successfully, it will notify the authors and continue with the deployment
- If the tests fail, the tag will be deleted from the repo. This way, all tags in the repo will contain a valid version
- Once the tests finished, a new job that will create the docker image and push it to the registry will be runned
- Approval for deploying in dev is needed, so, after the approval, a new job will modify the terraform files to update the state of the environment, changing the version of the deployed app to the new one
- Same with qa and prod

## CI/CD Secrets:
- `AWS_ACCESS_KEY_ID`: Key ID for accessing the AWS account
- `AWS_REGION`: Region where the application is deployed
- `AWS_SECRET_ACCESS_KEY`: Value for accessing the AWS account
- `AWS_SESSION_TOKEN`: AWS session token
- `DYNAMODB_TERRAFORM_LOCK_NAME`: Lock to prevent race conditions on the Terraform state stored in the S3 bucket
- `ECR_URL`: ECR URL once deployed
- `S3_TERRAFORM_STATE_NAME`: Bucket for storing the Terraform state
- `SLACK_WEBHOOK_URL`: Slack webhook for notifications
- `SMTP_SERVER`: SMTP server URL
- `SMTP_USERNAME`: Username for the SMTP server
- `SMTP_PASSWORD`: Password for the SMTP server
- `SMTP_PORT`: Port for the SMTP server
