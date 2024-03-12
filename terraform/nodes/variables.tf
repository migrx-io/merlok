variable "vpc_id" {
    type = string
    default = "vpc-095dc0635c6244fe3"
}

variable "subnet_id" {
    type = string
    default = "subnet-06b5191fc3bf0caff"
}

variable "vols_set" {
  type    = set(string)

  default = ["vol-0acb85c4b59133dc4",
             "vol-035f89785fc531fa0",
             "vol-0c99dd2f7ddf8d8e3"]

}
