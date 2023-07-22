resource "aws_iam_role" "api_gateway_execution" {
  name = "api_gateway_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

# Attach IAM role to the API Gateway
resource "aws_api_gateway_account" "api_gateway_account" {}

# Attach IAM policy to the IAM role for API Gateway execution
resource "aws_iam_policy_attachment" "api_gateway_invoke_lambda_policy_attachment" {
  name       = "api_gateway_invoke_lambda_policy_attachment"
  policy_arn = aws_iam_policy.api_gateway_invoke_lambda_policy.arn
  roles      = [aws_iam_role.api_gateway_execution.name]
}

# Create IAM policy for API Gateway to invoke the Lambda function
resource "aws_iam_policy" "api_gateway_invoke_lambda_policy" {
  name        = "api_gateway_invoke_lambda_policy"
  description = "IAM policy to allow API Gateway to invoke the Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = aws_lambda_function.chatgpt_lambda_function.arn
      }
    ]
  })
}

# API Gateway resource
resource "aws_api_gateway_rest_api" "chatgpt_detector_api" {
  name        = "chatgpt-detector-api"
  description = "ChatGPT Detector API"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway resource method
resource "aws_api_gateway_resource" "chatgpt_detector_resource" {
  rest_api_id = aws_api_gateway_rest_api.chatgpt_detector_api.id
  parent_id   = aws_api_gateway_rest_api.chatgpt_detector_api.root_resource_id
  path_part   = "api-chatgpt-detector"
}

# API Gateway resource method integration
resource "aws_api_gateway_method" "chatgpt_detector_method" {
  rest_api_id   = aws_api_gateway_rest_api.chatgpt_detector_api.id
  resource_id   = aws_api_gateway_resource.chatgpt_detector_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway resource method integration - Lambda
resource "aws_api_gateway_integration" "chatgpt_detector_integration" {
  rest_api_id = aws_api_gateway_rest_api.chatgpt_detector_api.id
  resource_id = aws_api_gateway_resource.chatgpt_detector_resource.id
  http_method = aws_api_gateway_method.chatgpt_detector_method.http_method
  type        = "AWS"
  uri         = aws_lambda_function.chatgpt_lambda_function.invoke_arn
  integration_http_method = "POST"
}

# API Gateway resource method integration response
resource "aws_api_gateway_integration_response" "chatgpt_detector_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.chatgpt_detector_api.id
  resource_id = aws_api_gateway_resource.chatgpt_detector_resource.id
  http_method = aws_api_gateway_method.chatgpt_detector_method.http_method
  status_code = "200"

  # Integration response key for AWS Lambda integration
  selection_pattern = ".*"  # Use this pattern to match any response from the Lambda function

  response_templates = {
    "application/json" = ""
  }
}

# API Gateway deployment
resource "aws_api_gateway_deployment" "chatgpt_detector_deployment" {
  rest_api_id = aws_api_gateway_rest_api.chatgpt_detector_api.id
  stage_name  = "test"
}

# Output the API Gateway URL after applying the configuration
output "api_gateway_url" {
  value = aws_api_gateway_deployment.chatgpt_detector_deployment.invoke_url
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id   = aws_api_gateway_rest_api.chatgpt_detector_api.id
  resource_id   = aws_api_gateway_resource.chatgpt_detector_resource.id
  http_method   = aws_api_gateway_method.chatgpt_detector_method.http_method
  status_code   = "200"

  response_models = {
    "application/json" = "Empty"  # Replace "Empty" with the model you want to use for the response body if any
  }
}