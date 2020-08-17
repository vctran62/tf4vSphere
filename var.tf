variable "user" {
    type = "string"
}
variable "password" {
    type = "string"
}
variable "host" {
    type = "string"
}

variable "region" {
    type = "string"
    default="devcloud"
}
variable "datastore" {
    type = "string"
    default="vmstore"
}
variable "cluster" {
    type = "string"
    default="fenrir"
}
variable "network_interface" {
    type = "string"
    default="portGroup-1004"
}

variable "templateName" {
    type = "string"
    default="windows2012"
}

variable "vmname" {
    type = "string"
    default="vmdomian"
}

variable "foldername" {
    type = "string"
    default="terraform-test-folder"
}
variable "offset" {
    default = 1
}

variable "count" {
default =2
}
