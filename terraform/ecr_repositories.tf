
# Create ECR repositories
resource "aws_ecr_repository" "chatgptdetector_inference" {
  name = "chatgptdetector-inference"
}

resource "aws_ecr_repository" "chatgptdetector_model" {
  name = "chatgptdetector-model"
}