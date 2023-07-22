# IAM Role for the Lambda function's execution role
resource "aws_iam_role" "lambda_execution" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "chatgpt_lambda_function" {
  function_name = "chatgpt-detector-lambda"
  role          = aws_iam_role.lambda_execution.arn  # The ARN of the IAM role for the Lambda function

  runtime = "python3.10"  # Use Python 3.10 runtime
  handler = "lambda_function.lambda_function.lambda_handler"  # The name of the Python file (lambda_function.py) and the handler function

  # The source code for the Lambda function (Python code)
  filename      = "lambda.zip"  # Path to your Lambda function code ZIP file
  source_code_hash = filebase64sha256("lambda.zip")  # Compute the hash of the ZIP file

  # Environment variables for the Lambda function
  environment {
    variables = {
      ENDPOINT_NAME = "chatgptdetector-endpoint"
    }
  }
}

resource "aws_iam_policy" "lambda_invoke_endpoint_policy" {
  name        = "lambda_invoke_endpoint_policy"
  description = "IAM policy to allow Lambda to invoke the SageMaker endpoint"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sagemaker:InvokeEndpoint"
        Resource = "arn:aws:sagemaker:ap-southeast-2:373770620841:endpoint/chatgptdetector-endpoint"
      }
    ]
  })
}

# IAM policy attachment to allow Lambda to invoke the endpoint
resource "aws_iam_policy_attachment" "lambda_execution_policy_attachment" {
  name       = "lambda_execution_policy_attachment"
  policy_arn = aws_iam_policy.lambda_invoke_endpoint_policy.arn
  roles      = [aws_iam_role.lambda_execution.name]
}


# Lambda function trigger for the chatgpt-detector-api
resource "aws_lambda_permission" "api_trigger" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chatgpt_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # Replace "3iyy9gezd5" with the actual API Gateway ID (chatgpt-detector-api)
  source_arn    = "arn:aws:execute-api:ap-southeast-2:373770620841:3iyy9gezd5/*/*/*"
}