variable "vpc_id" {
    type = string
    default = "vpc-0e9df47a12c0c56bb"
}

variable "subnet_a" {
    type = string
    default = "subnet-06051faaef0609f70"
}

variable "subnet_b" {
    type = string
    default = "subnet-06051faaef0609f70"
}

variable "subnet_c" {
    type = string
    default = "subnet-06051faaef0609f70"
}


variable "vols_set" {
  type    = set(string)

  default = ["vol-06fcb2232117630fc",
             "vol-0c97886afe85f76e0",
             "vol-02b672067ee61b5f2",
             "vol-0f3827a0aff09746e",
             "vol-0485798344acb962c",
             "vol-024fc0d18bd016980"]

}
