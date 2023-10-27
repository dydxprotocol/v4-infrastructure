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
# Data pointing to the node ECR repository
# For test-nets ECR repositories are in us-east-2
# For main-net ECR repositories are in ap-northeast-1
# Provider can't be provided dynamitcally, so create separate data blocks for each region

data "aws_ecr_repository" "full_node_us_east_2" {
  count    = var.environment == "mainnet" ? 0 : 1
  provider = aws.us-east-2
  name     = var.full_node_ecr_repository_name
}

data "aws_ecr_repository" "snapshot_full_node_us_east_2" {
  count    = var.environment == "mainnet" ? 0 : 1
  provider = aws.us-east-2
  name     = var.snapshot_full_node_ecr_repository_name
}

data "aws_ecr_repository" "full_node_ap_northeast_1" {
  count = var.environment == "mainnet" ? 1 : 0
  name  = var.full_node_ecr_repository_name
}

data "aws_ecr_repository" "snapshot_full_node_ap_northeast_1" {
  count = var.environment == "mainnet" ? 1 : 0
  name  = var.snapshot_full_node_ecr_repository_name
}
