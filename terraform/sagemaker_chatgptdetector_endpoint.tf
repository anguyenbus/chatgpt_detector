resource "aws_sagemaker_model" "chatgptdetector" {
  name             = "chatgptdetector"
  primary_container {
    container_hostname = "chatgptdetector"
    mode = "SingleModel"
    image       = "373770620841.dkr.ecr.ap-southeast-2.amazonaws.com/chatgptdetector-inference:chatgptdetector_image"
    model_data_url  = var.model-data
  }

  execution_role_arn = "arn:aws:iam::373770620841:role/SageMaker-MLOsEngineer"
  enable_network_isolation = false
}

resource "aws_sagemaker_endpoint_configuration" "chatgptdetector" {
  name = "chatgptdetector-endpoint-config"

  production_variants {
    variant_name      = "AllTraffic"
    model_name        = aws_sagemaker_model.chatgptdetector.name
    initial_instance_count = 1
    instance_type     = "ml.m4.xlarge"
  }
}

resource "aws_sagemaker_endpoint" "chatgptdetector" {
  name   = "chatgptdetector-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.chatgptdetector.name
}

