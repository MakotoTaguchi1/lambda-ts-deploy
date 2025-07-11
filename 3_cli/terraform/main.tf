resource "aws_lambda_function" "ts_deploy_test" {
  filename      = data.archive_file.lambda_zip.output_path # ローカルに作成された.zipファイルを指定
  function_name = "ts-cli-deploy-test"
  role          = aws_iam_role.lambda_execution.arn
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  timeout       = 30
  memory_size   = 512

  lifecycle {
    ignore_changes = [
      filename,
      environment
    ]
  }
}

# terraform 上で Zip ファイルとして lambda コードを作成
# ソースコード管理用リポジトリにてコード管理しているので、ここでは Zip ファイルを作成するだけ
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/ts-cli-deploy-test.zip" # ローカルのカレントディレクトリに.zipファイルが作成される

  source {
    content  = "not_use_here" # 本来ソースコードはここに書くが、terraform管理しないので書かない。初回 apply 時のみ適用される。
    filename = "index.js"
  }
}

resource "aws_iam_role" "lambda_execution" {
  name = "lambda-ts-cli-deploy-test-execution-role"

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

# IAM policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
