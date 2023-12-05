resource "aws_dynamodb_table" "lighting_dynamodb_table" {
  name         = var.database_tables_names[0]
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table" "heating_dynamodb_table" {
  name         = var.database_tables_names[1]
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "N"
  }
}
