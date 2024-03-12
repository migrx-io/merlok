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

  default = ["vol-0b600506b4b3f62f0",
             "vol-0fd8512a5808b6e67",
             "vol-043d10ff5797ec594",
             "vol-00ae68c5392cbddb0",
             "vol-0fd299dc05cbca65c",
             "vol-05c4a321551e462fb"]

}
