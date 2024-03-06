# Amplitude API gateway

## Deployment

* Create a dedicated workspace in Terraform Cloud.
* Create a dedicated AWS account.
* In the account create an IAM user: `terraformer` with the `AmazonAPIGatewayAdministrator` policy attached directly.
* Create a an IAM access key for the user.
* In the Terraform Cloud workspace add `env` variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
* Apply.
