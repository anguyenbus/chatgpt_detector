# ChatGPT Detector

## Table of Contents

- [ChatGPT Detector](#chatgpt-detector)
  - [Table of Contents](#table-of-contents)
  - [About ](#about-)
  - [Test ](#test-)
  - [Project Structure ](#project-structure-)

## About <a name = "about"></a>

ChatGPT Detector is a project focused on creating a robust system for identifying and detecting instances of ChatGPT-generated text. In a world where AI language models are extensively used, it becomes imperative to have tools that can differentiate between content produced by humans and content generated by AI. This project offers a practical solution to empower users in verifying the authenticity of text and combatting the spread of misinformation and deceptive information propagated by AI language models.

Notably, the primary emphasis of this project lies in presenting an end-to-end machine learning design rather than solely prioritizing model performance. By providing comprehensive guidelines and suggestions, the project aims to equip developers and researchers with the knowledge and tools needed to build similar systems effectively. The focus is on delivering a well-structured and efficient machine learning pipeline to address the specific challenge of detecting ChatGPT-generated content, promoting transparency, and encouraging further research in the field.

## Test <a name = "test"></a>

The simplest way is to test with curl
```
curl -X POST -H "Content-Type: application/json" -d '{"input_text": "this is the input test"}' https://3iyy9gezd5.execute-api.ap-southeast-2.amazonaws.com/test/api-chatgpt-detector
```

## Project Structure <a name = "Structure"></a>
chatgpt_detector             # Root directory

│   README.md                # File: README.md containing project information
│   requirements.txt         # File: requirements.txt specifying Python dependencies

├───.github                  # Directory: .github containing GitHub workflow configuration
│   └───workflows
│           deploy.yml       # File: deploy.yml defining GitHub workflow for deployment

├───data                     # Directory: data containing training data
│       training_data.txt    # File: training_data.txt containing training data

├───inference                # Directory: inference containing files for inference
│       .env                 # File: .env containing environment variables
│       Dockerfile           # File: Dockerfile for running inference
│       inference.py         # File: inference.py for inference code

├───model                    # Directory: model containing files related to the model
│       constants.py         # File: constants.py defining constants for the model
│       Dockerfile           # File: Dockerfile for training the model
│       run.sh               # File: run.sh for executing model training
│       s3_helper.py         # File: s3_helper.py providing helper functions for S3 interactions
│       train.py             # File: train.py for model training script

└───terraform                # Directory: terraform containing Terraform configuration
    │   api_gateway.tf       # File: api_gateway.tf for AWS API Gateway configuration
    │   ecr_repositories.tf  # File: ecr_repositories.tf for AWS ECR repositories configuration
    │   lambda.tf            # File: lambda.tf for AWS Lambda function configuration
    │   lambda.zip           # File: lambda.zip containing AWS Lambda function code
    │   provider.tf          # File: provider.tf specifying Terraform provider configuration
    │   s3.tf                # File: s3.tf for AWS S3 bucket configuration
    │   sagemaker_chatgptdetector_endpoint.tf  # File: sagemaker_chatgptdetector_endpoint.tf for SageMaker endpoint configuration
    │   sagemaker_iam.tf      # File: sagemaker_iam.tf for AWS IAM roles and policies configuration
    │   terraform.tfstate     # File: terraform.tfstate for Terraform state information
    │   terraform.tfstate.backup  # File: terraform.tfstate.backup for Terraform state backup
    │   variables.tf         # File: variables.tf for Terraform variable definitions
