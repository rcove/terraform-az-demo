variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of ssh key pair"
}
variable "resource_group" {
}
variable "vnet_cidr" {
}
variable "dc_location" {
}
variable "external1_subnet_cidr" {
}
variable "external2_subnet_cidr" {
}
variable "internal1_subnet_cidr" {
}
variable "internal2_subnet_cidr" {
}
variable "webserver1_subnet_cidr" {
}
variable "webserver2_subnet_cidr" {
}
variable "app1_subnet_cidr" {
}
variable "my_user_data" {
}
variable "ubuntu_user_data" {
}
variable "externaldnshost" {
}
variable "cg_size" {
}
variable "ws_size" {
}
variable "r53zone" {
}
variable "SICKey" {
}
variable "AllowUploadDownload" {
}
variable "pwd_hash" {
}
