resource "aws_dynamodb_table" "dynamodb_table" {
  count        = length(var.database_tables_names)
  name         = var.database_tables_names[count.index]
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name = "${var.database_tables_names[count.index]}-dynamodb-table"
  }
}
