
provider "aws" {
  access_key = "fakeAccessKey"
  secret_key = "fakeSecretKey"
  region = "us-east-1"
  insecure = true
  max_retries = 3
  skip_credentials_validation = true
  skip_requesting_account_id = true
  skip_metadata_api_check = true
  endpoints {
    apigateway = "http://localhost:4567"
    lambda = "http://localhost:4574"
  }
}

resource "aws_api_gateway_rest_api" "api" {
  api_key_source = "HEADER"
  name = "myapi"
  lifecycle {
    ignore_changes = ["api_key_source"]
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = "live"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  cache_key_parameters = []
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  request_parameters = {}
  request_templates = {}
  timeout_milliseconds = 29000
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://www.google.com"
  lifecycle {
    ignore_changes = [
      "cache_key_parameters",
      "cache_namespace",
      "id",
      "integration_http_method",
      "request_parameters",
      "timeout_milliseconds"
    ]
  }
}

resource "aws_lambda_function" "lambda1" {
  s3_bucket = "__local__"
  s3_key = "${path.cwd}"
  function_name = "lambda1"
  role          = "123456"
  handler       = "packages/project/dist/src/index1.handler"
  runtime       = "nodejs10.x"
}

resource "aws_lambda_function" "lambda2" {
  s3_bucket = "__local__"
  s3_key = "${path.cwd}"
  function_name = "lambda2"
  role          = "123456"
  handler       = "packages/project/dist/src/index2.handler"
  runtime       = "nodejs10.x"
}