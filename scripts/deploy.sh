#!/bin/bash
# deploy.sh - Deploy de templates CloudFormation
# Uso: ./deploy.sh template.yaml STACK_NAME KEY_NAME

TEMPLATE_FILE=$1
STACK_NAME=$2
KEY_NAME=$3

if [ -z "$TEMPLATE_FILE" ] || [ -z "$STACK_NAME" ] || [ -z "$KEY_NAME" ]; then
    echo "Uso: ./deploy.sh template.yaml STACK_NAME KEY_NAME"
    exit 1
fi

aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --parameters ParameterKey=KeyName,ParameterValue=$KEY_NAME \
    --capabilities CAPABILITY_NAMED_IAM

echo "Stack $STACK_NAME criada a partir do template $TEMPLATE_FILE"
