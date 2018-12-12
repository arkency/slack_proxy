# SlackProxy on AWS Lambda

## Prerequisites

It is assumed that you have and configured [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) and [SAM CLI](https://aws.amazon.com/serverless/sam/) on your machine and your IAM does not lack required permissions. A [S3 bucket](https://console.aws.amazon.com/s3/) will be needed to distribute code package as well. When in doubt, consult AWS documentation.

## Pushing to production

    make deploy

## Development

Install development dependencies, runs unit tests and finally mutate the code:

    make install test mutate
    
If you wish to conduct manual tests, this boots application server to http://localhost:9292

    SLACK_USERNAME=panda SLACK_WEBHOOK_URL=http://hooks.slack.com/and_the_rest make serve