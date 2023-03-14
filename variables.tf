variable "region" {
  description = "value"
  type = string
  default = "ap-south-1"
}
variable "iot_name" {
  description = "value"
  type        = string

}
variable "First" {
  description = "value"
  type        = string
  default = "IOT-Thing"

}

variable "bucket_name" {
  description = "value"
  type = string
}

variable "kinesis_name" {
  description = "value"
  type        = string

}
variable "shard_count" {
  description = "value"
  type        = string

}
variable "retention_period" {
  description = "value"
  type        = string
  default = "48"

}
variable "stream_mode" {
  description = "value"
  type        = string
  default = "PROVISIONED"

}

# variable "filename" {
#     description = "value"
#    type = string 
  
# }
variable "function_name" {
    description = "value"
   type = string 
  
}
variable "role" {
    description = "value"
   type = string 
  
}
variable "handler" {
    description = "value"
   type = string 
   default = "index.js"
  
}
variable "runtime" {
    description = "value"
   type = string 
  
}
