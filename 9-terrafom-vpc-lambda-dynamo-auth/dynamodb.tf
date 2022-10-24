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

resource "aws_dynamodb_table_item" "states" {
  table_name = aws_dynamodb_table.tectonic_dynamodb_table.name
  hash_key   = aws_dynamodb_table.tectonic_dynamodb_table.hash_key
  range_key  = aws_dynamodb_table.tectonic_dynamodb_table.range_key

  for_each = {
    "1" = { TRAN_TYP_CD = "NB", ST_CD = "MN", ACS_DT = "2020-10-10", BU_CD = "ALL", E_DT = "2020-10-10", PRDCT_ELIG_CD = "CT", P_GRP_CD = "BAP" }
    "2" = { TRAN_TYP_CD = "NC", ST_CD = "MN", ACS_DT = "2020-10-10", BU_CD = "ALL", E_DT = "2020-10-10", PRDCT_ELIG_CD = "CT", P_GRP_CD = "BAP" }
    "3" = { TRAN_TYP_CD = "ND", ST_CD = "MN", ACS_DT = "2020-10-10", BU_CD = "ALL", E_DT = "2020-10-10", PRDCT_ELIG_CD = "CT", P_GRP_CD = "BAP" }
    "4" = { TRAN_TYP_CD = "NB", ST_CD = "FL", ACS_DT = "2021-10-10", BU_CD = "ALL", E_DT = "2021-10-10", PRDCT_ELIG_CD = "CT", P_GRP_CD = "BAP" }
    "5" = { TRAN_TYP_CD = "NC", ST_CD = "FL", ACS_DT = "2021-10-10", BU_CD = "ALL", E_DT = "2021-10-10", PRDCT_ELIG_CD = "CT", P_GRP_CD = "BAP" }
    "6" = { TRAN_TYP_CD = "ND", ST_CD = "FL", ACS_DT = "2021-10-10", BU_CD = "ALL", E_DT = "2021-10-10", PRDCT_ELIG_CD = "CT", P_GRP_CD = "BAP" }
  }

  item = <<ITEM
       {
         "TRAN_TYP_CD" : {"S" : "${each.value.TRAN_TYP_CD}"},
         "ST_CD" : {"S" : "${each.value.ST_CD}"},
         "ACS_DT" : { "S" : "${each.value.ACS_DT}"},
         "BU_CD" : { "S" : "${each.value.BU_CD}"},
         "E_DT" : { "S" : "${each.value.E_DT}"},
         "PRDCT_ELIG_CD" : { "S" : "${each.value.PRDCT_ELIG_CD}"},
         "P_GRP_CD" : { "S" : "${each.value.P_GRP_CD}"}
       }
    ITEM
}

