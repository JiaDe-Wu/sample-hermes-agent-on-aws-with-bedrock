#!/bin/bash
###############################################################################
# Hermes Agent on AWS — Deployment Script
# Usage: ./deploy.sh [stack-name] [region] [keypair-name]
###############################################################################
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

STACK_NAME=${1:-hermes-bedrock}
REGION=${2:-us-east-2}
KEYPAIR_NAME=${3}

echo -e "${BLUE}=========================================="
echo " Hermes Agent on AWS — Deployment"
echo "==========================================${NC}"
echo ""
echo "Stack:  $STACK_NAME"
echo "Region: $REGION"
echo ""

# Check prerequisites
echo -e "${BLUE}[1/4] Checking prerequisites...${NC}"

if ! command -v aws &> /dev/null; then
    echo -e "${RED}✗ AWS CLI not installed${NC}"
    echo "  Install: https://aws.amazon.com/cli/"
    exit 1
fi

if ! aws sts get-caller-identity --region "$REGION" &> /dev/null; then
    echo -e "${RED}✗ AWS credentials not configured${NC}"
    echo "  Run: aws configure"
    exit 1
fi

if ! command -v session-manager-plugin &> /dev/null; then
    echo -e "${YELLOW}⚠ SSM Session Manager Plugin not installed${NC}"
    echo "  Install: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html"
    echo ""
fi

echo -e "${GREEN}✓ Prerequisites OK${NC}"
echo ""

# Get keypair
if [ -z "$KEYPAIR_NAME" ]; then
    echo -e "${YELLOW}Available key pairs in $REGION:${NC}"
    aws ec2 describe-key-pairs --region "$REGION" --query 'KeyPairs[*].KeyName' --output table
    echo ""
    read -p "Enter key pair name: " KEYPAIR_NAME
    if [ -z "$KEYPAIR_NAME" ]; then
        echo -e "${RED}✗ Key pair name required${NC}"
        exit 1
    fi
fi

# Deploy
echo -e "${BLUE}[2/4] Deploying CloudFormation stack...${NC}"

aws cloudformation create-stack \
  --stack-name "$STACK_NAME" \
  --template-body file://hermes-bedrock.yaml \
  --parameters \
    ParameterKey=KeyPairName,ParameterValue="$KEYPAIR_NAME" \
    ParameterKey=BedrockModel,ParameterValue=us.anthropic.claude-sonnet-4-6 \
    ParameterKey=InstanceType,ParameterValue=t3.medium \
    ParameterKey=CreateVPCEndpoints,ParameterValue=true \
  --capabilities CAPABILITY_IAM \
  --region "$REGION"

echo -e "${GREEN}✓ Stack creation started${NC}"
echo ""

# Wait
echo -e "${BLUE}[3/4] Waiting for deployment (~8 minutes)...${NC}"
echo "  Monitor: https://console.aws.amazon.com/cloudformation/home?region=$REGION"
echo ""

aws cloudformation wait stack-create-complete \
  --stack-name "$STACK_NAME" \
  --region "$REGION"

echo -e "${GREEN}✓ Deployment complete${NC}"
echo ""

# Get outputs
echo -e "${BLUE}[4/4] Connection info${NC}"

INSTANCE_ID=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query 'Stacks[0].Outputs[?OutputKey==`InstanceId`].OutputValue' \
  --output text \
  --region "$REGION")

MODEL=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query 'Stacks[0].Outputs[?OutputKey==`BedrockModel`].OutputValue' \
  --output text \
  --region "$REGION")

echo -e "${GREEN}=========================================="
echo " ✓ Hermes Agent is ready!"
echo "==========================================${NC}"
echo ""
echo "Instance: $INSTANCE_ID"
echo "Model:    $MODEL"
echo "Region:   $REGION"
echo ""
echo -e "${YELLOW}Connect:${NC}"
echo -e "${BLUE}  aws ssm start-session --target $INSTANCE_ID --region $REGION${NC}"
echo ""
echo -e "${YELLOW}Then:${NC}"
echo -e "${BLUE}  hermes chat${NC}                  # Start chatting"
echo -e "${BLUE}  hermes model${NC}                 # Switch models"
echo -e "${BLUE}  hermes gateway setup${NC}         # Connect Telegram/Discord/Slack"
echo ""
echo -e "${YELLOW}Cleanup:${NC}"
echo -e "${BLUE}  aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION${NC}"
echo ""
