# -----------------------------------------------------------------------------
# Indexer ECS Services
# -----------------------------------------------------------------------------
# Container Registry where container images for indexer services are published.
resource "aws_ecr_repository" "main" {
  for_each = local.services

  name                 = "${var.environment}-indexer-${each.key}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Container Registry Lifecycle Policy to limit total # of images to retain.
resource "aws_ecr_lifecycle_policy" "main" {
  for_each   = aws_ecr_repository.main
  repository = each.value.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 100 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 100
      }
    }]
  })
}

# -----------------------------------------------------------------------------
# Indexer Lambda Services
# -----------------------------------------------------------------------------
# Container Registry for Lambda services
resource "aws_ecr_repository" "lambda_services" {
  for_each = local.lambda_services

  name                 = "${var.environment}-indexer-${each.key}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Container Registry Lifecycle Policy to limit total # of images to retain.
resource "aws_ecr_lifecycle_policy" "lambda_services" {
  for_each = local.lambda_services

  repository = aws_ecr_repository.lambda_services[each.key].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 100 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 100
      }
    }]
  })
}

# -----------------------------------------------------------------------------
# Full Node
# -----------------------------------------------------------------------------
# Data pointing to the validator ECR repository
data "aws_ecr_repository" "validator" {
  provider = aws.us-east-2
  name     = var.full_node_ecr_repository_name
}

data "aws_ecr_repository" "snapshot_validator" {
  provider = aws.us-east-2
  name     = var.snapshot_full_node_ecr_repository_name
}
