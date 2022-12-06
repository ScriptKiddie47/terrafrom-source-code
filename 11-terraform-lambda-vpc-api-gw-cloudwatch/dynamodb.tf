resource "aws_dynamodb_table" "tectonic_dynamodb_table" {
  name           = "tectonic"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "TRAN_TYP_CD"
  range_key      = "ST_CD"

  attribute {
    name = "TRAN_TYP_CD"
    type = "S"
  }

  attribute {
    name = "ST_CD"
    type = "S"
  }

  attribute {
    name = "E_DT"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  local_secondary_index {
    name            = "E_DT_Index"
    range_key       = "E_DT"
    projection_type = "ALL"
  }

  tags = {
    Name        = "dynamodb_table_tectonic"
    Environment = "dev"
  }
}