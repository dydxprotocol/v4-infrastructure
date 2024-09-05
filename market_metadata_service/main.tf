resource "null_resource" "install_python_dependencies" {
  provisioner "local-exec" {
    command = "pip3 install -r ./src/requirements.txt -t ./src"
  }

  triggers = {
    trigger = timestamp()
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src/lambda_function.zip"
  excludes = [
    "venv",
    "_pycache_"
  ]
  depends_on = [
    null_resource.install_python_dependencies
  ]
}

resource "aws_lambda_function" "market_metadata_service" {
  function_name    = "market-metadata-service"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "python3.12"
  handler = "lambda_function.lambda_handler"
  timeout = 60

  role = aws_iam_role.lambda_executor.arn

  depends_on = [
    data.archive_file.lambda_zip
  ]
}
