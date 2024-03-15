variable "vpc_id" {
    type = string
    default = "vpc-0e9df47a12c0c56bb"
}

variable "subnet_id" {
    type = string
    default = "subnet-06051faaef0609f70"
}

variable "vols_set" {
  type    = set(string)

  default = ["vol-00f0c199ca2e27a20",
             "vol-02e409ae9627662ae",
             "vol-0ff679bc793eb4686",
             "vol-02d9b03b74b3f9a7b",
             "vol-0bd2c8c753ddde929",
             "vol-030981665b81891d1"]

}
