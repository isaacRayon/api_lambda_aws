#!/usr/bin/env bash
export ENV="dev"
export REGION="${Region:=us-east-2}"
export CODE_PIPELINE_BUCKET="$ENV-blau-ds"
export STACK_NAME="aws-blau"
export S3_FILES_LOC="s3://blau-ds/$STACK_NAME/"


display_help() {
   echo "======================================"
   echo "   AWS Test deployer"
   echo "======================================"
   echo "Syntax: deploy [command]"
   echo
   echo "---commands---"
   echo "help                   Print  help"
   echo "all                    Deploy all"
   echo "pyspark                Deploy pyspark only"
   echo "sam                    Deploy SAM only"
   echo
}

# SAM deployment
deploy_sam() {
   echo "Attempting SAM deployment"

   sam build \
   --parameter-overrides "ParameterKey=EnvStageName,ParameterValue=$ENV ParameterKey=Region,ParameterValue=$REGION"
   
   sam package \
   --output-template-file packaged.yaml \
   --s3-bucket blau-ds \
   
   sam deploy \
   --template-file packaged.yaml \
   --stack-name $STACK_NAME \
   --region $REGION \
   --capabilities CAPABILITY_AUTO_EXPAND \
   --parameter-overrides "ParameterKey=EnvStageName,ParameterValue=$ENV ParameterKey=Region,ParameterValue=$REGION"
   
   echo "SAM deployment done"
}


case "$1" in
   all)
      deploy_sam
      ;;
   pyspark)
      deploy_pyspark
      ;;
   sam)
      deploy_sam
      ;;
   *)
      echo "No command specified, displaying help"
      display_help
      ;;
esac
