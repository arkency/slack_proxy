# serverless-getdpd-slack

## Before first run

* install and configure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html), make you sure your IAM permission allow S3 access and CloudFormation execution
* install [SAM CLI](https://aws.amazon.com/serverless/sam/)
* create [S3 bucket](https://console.aws.amazon.com/s3/)

## Getting it running for the first time

```
bundle install

bundle install --deployment

sam package \
     --template-file template.yaml \
     --output-template-file serverless-output.yaml \
     --s3-bucket serverless-getdpd-slack

sam deploy \
     --template-file serverless-output.yaml \
     --stack-name serverless-getdpd-slack \
     --capabilities CAPABILITY_IAM
