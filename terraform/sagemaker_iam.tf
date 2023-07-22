# Create the IAM role
resource "aws_iam_role" "sagemaker_mlos_engineer" {
  name = "SageMaker-MLOsEngineer"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the "AmazonS3FullAccess" managed policy to the role
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}

# Attach the "AmazonSageMakerFullAccess" managed policy to the role
resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}

# Attach the "IAMFullAccess" managed policy to the role
resource "aws_iam_role_policy_attachment" "iam_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}

# Attach the "CloudWatchFullAccess" managed policy to the role
resource "aws_iam_role_policy_attachment" "cloudwatch_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}

# Attach the "EC2InstanceProfileForImageBuilderECRContainerBuilds" managed policy to the role
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}

# Create the IAM policy for SM_EndpointDeployment
data "aws_iam_policy_document" "sagemaker_deployment_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "sagemaker:CreateEndpointConfig",
      "sagemaker:CreateEndpoint",
      "sagemaker:DeleteEndpointConfig",
      "sagemaker:DeleteEndpoint",
      "sagemaker:UpdateEndpoint",
      "sagemaker:UpdateEndpointWeightsAndCapacities",
      "sagemaker:DescribeEndpoint",
      "sagemaker:DescribeEndpointConfig",
    ]
    resources = ["arn:aws:sagemaker:*:*:*/*"]
  }

  statement {
    effect  = "Allow"
    actions = [
      "sagemaker:ListEndpoints",
      "sagemaker:ListEndpointConfigs",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "sagemaker_deployment_policy" {
  name        = "SM_EndpointDeployment"
  policy      = data.aws_iam_policy_document.sagemaker_deployment_policy.json
}

# Attach the IAM policy for SM_EndpointDeployment to the IAM role
resource "aws_iam_role_policy_attachment" "sagemaker_deployment_attachment" {
  policy_arn = aws_iam_policy.sagemaker_deployment_policy.arn
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}

# Create the IAM policy for SM_ExperimentsVisualization
data "aws_iam_policy_document" "sagemaker_visualization_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "sagemaker:DescribeAction",
      "sagemaker:DescribeArtifact",
      "sagemaker:DescribeContext",
      "sagemaker:DescribeExperiment",
      "sagemaker:DescribeTrial",
      "sagemaker:DescribeTrialComponent",
      "sagemaker:DescribeLineageGroup",
    ]
    resources = ["arn:aws:sagemaker:*:*:*/*"]
  }

  statement {
    effect  = "Allow"
    actions = [
      "sagemaker:ListAssociations",
      "sagemaker:ListActions",
      "sagemaker:ListArtifacts",
      "sagemaker:ListContexts",
      "sagemaker:ListExperiments",
      "sagemaker:ListTrials",
      "sagemaker:ListTrialComponents",
      "sagemaker:ListLineageGroups",
      "sagemaker:GetLineageGroupPolicy",
      "sagemaker:QueryLineage",
      "sagemaker:Search",
      "sagemaker:GetSearchSuggestions",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "sagemaker_visualization_policy" {
  name        = "SM_ExperimentsVisualization"
  policy      = data.aws_iam_policy_document.sagemaker_visualization_policy.json
}

# Attach the IAM policy for SM_ExperimentsVisualization to the IAM role
resource "aws_iam_role_policy_attachment" "sagemaker_visualization_attachment" {
  policy_arn = aws_iam_policy.sagemaker_visualization_policy.arn
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}

# Create the IAM policy for SM_ModelManagement
data "aws_iam_policy_document" "sagemaker_model_management_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "sagemaker:CreateModel",
      "sagemaker:CreateModelPackage",
      "sagemaker:CreateModelPackageGroup",
      "sagemaker:DescribeModel",
      "sagemaker:DescribeModelPackage",
      "sagemaker:DescribeModelPackageGroup",
      "sagemaker:BatchDescribeModelPackage",
      "sagemaker:UpdateModelPackage",
      "sagemaker:DeleteModel",
      "sagemaker:DeleteModelPackage",
      "sagemaker:DeleteModelPackageGroup",
    ]
    resources = ["arn:aws:sagemaker:*:*:*/*"]
  }

  statement {
    effect  = "Allow"
    actions = [
      "sagemaker:ListModels",
      "sagemaker:ListModelPackages",
      "sagemaker:ListModelPackageGroups",
    ]
    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::373770620841:role/SageMaker-MLOsEngineer"
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "sagemaker_model_management_policy" {
  name        = "SM_ModelManagement"
  policy      = data.aws_iam_policy_document.sagemaker_model_management_policy.json
}

# Attach the IAM policy for SM_ModelManagement to the IAM role
resource "aws_iam_role_policy_attachment" "sagemaker_model_management_attachment" {
  policy_arn = aws_iam_policy.sagemaker_model_management_policy.arn
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}

# Create the IAM policy for SM_PipelineManagement
data "aws_iam_policy_document" "sagemaker_pipeline_management_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "sagemaker:CreatePipeline",
      "sagemaker:StartPipelineExecution",
      "sagemaker:StopPipelineExecution",
      "sagemaker:RetryPipelineExecution",
      "sagemaker:UpdatePipelineExecution",
      "sagemaker:SendPipelineExecutionStepSuccess",
      "sagemaker:SendPipelineExecutionStepFailure",
      "sagemaker:DescribePipeline",
      "sagemaker:DescribePipelineExecution",
      "sagemaker:DescribePipelineDefinitionForExecution",
      "sagemaker:DeletePipeline",
    ]
    resources = ["arn:aws:sagemaker:*:*:*/*"]
  }

  statement {
    effect  = "Allow"
    actions = [
      "sagemaker:ListPipelines",
      "sagemaker:ListPipelineExecutions",
      "sagemaker:ListPipelineExecutionSteps",
      "sagemaker:ListPipelineParametersForExecution",
    ]
    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::373770620841:role/SageMaker-MLOsEngineer"
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "sagemaker_pipeline_management_policy" {
  name        = "SM_PipelineManagement"
  policy      = data.aws_iam_policy_document.sagemaker_pipeline_management_policy.json
}

# Attach the IAM policy for SM_PipelineManagement to the IAM role
resource "aws_iam_role_policy_attachment" "sagemaker_pipeline_management_attachment" {
  policy_arn = aws_iam_policy.sagemaker_pipeline_management_policy.arn
  role       = aws_iam_role.sagemaker_mlos_engineer.name
}
