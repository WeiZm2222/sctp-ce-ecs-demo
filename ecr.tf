# Use this to create your own ecr private registry
# Afterwards, you may also add in a Dockerfile to create a Docker image
# and push the image to your private registry
# You can then replace task definition > image to point to your 
# created image

#resource "aws_ecr_repository" "my_repository" {
#    name = "zmw-ecr-repo311"
#    image_tag_mutability = "MUTABLE"
#    image_scanning_configuration {
#      scan_on_push = true
#    }
#}
