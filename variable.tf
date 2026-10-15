variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "multitier-web-app"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
