
variable "github_org" {
  default = "SangMinKimxx"
}

variable "github_token" {
}

variable "project" {
	default = "meteor"
}

variable "app" {
	default = "meteor"
}
variable "production" {
	default = "production"
}

variable "website_bucket_name" {
	default = "meteor-website"
}
variable "docker_build_image" {
  default ="aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}