# Comment out the below if you are working on local

terraform {
  backend "s3" {
    bucket = "sctp-ce3-tfstate-bucket-1"
    key    = "ecs-fargate-zmw.tfstate" # Change the value of this to yourname-tf-workspace-act.tfstate for  example. it also contains the ids that will correspond with those int he cloud. Multiple members in same team working on the code shoudl share the same statefile. 
    region = "us-east-1"
  }
}
