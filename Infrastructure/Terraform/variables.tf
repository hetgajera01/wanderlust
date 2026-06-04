variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.small"
}

variable "Jenkins" {
    type = map(object({
      node_name = string
      instance_type=string
      volume_size=number
    }))
    default = {
      "master" = {
        node_name = "Jenkins-master"
        instance_type="m7i-flex.large"
        volume_size=30
      }
      "worker"={
        node_name="Jenkins-worker"
        instance_type="t3.small"
        volume_size=50
      }
    }
}