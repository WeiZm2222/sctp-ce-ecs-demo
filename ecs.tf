# Creates a task definition using the files/task-definition.json
# HINT: if you would like to use your own docker image, update the container_definitions image_url
# accordingly

resource "aws_ecs_task_definition" "own_task_definition" {
  family                = "zmw-taskdef-tf" # Update accordingly
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn        = var.ex_role_arn
  cpu                   =   256
  memory                = 512

  container_definitions = templatefile("./files/task-definition.json", {
    image_url        = "255945442255.dkr.ecr.us-east-1.amazonaws.com/zmw-ecr-repo311:v2"
    container_name   = "311-container-zmw"
    port_name = "zmw-test-ecs-8080-tcp"
    log_group_region = "us-east-1"
    log_group_name   = "/ecs/zmw-taskdef-tf" # Update accordingly
    log_group_prefix = "ecs"
  })

# container_definitions = <<EOF
#[
 # {
  #  "name": "311-container", 
   # "image": "255945442255.dkr.ecr.us-east-1.amazonaws.com/zmw-ecr-repo311:v2",
   # "memory": 512,
   # "cpu": 256,
   # "essential": true,
   # "entryPoint": ["/"],
   # "portMappings": [
   #   {
   #     "containerPort": 80,
   #     "hostPort": 80
   #   }
   # ]
  #}
#]
#EOF
}

# Creates an ecs cluster

resource "aws_ecs_cluster" "own_cluster" {
  name = "zmw-cluster-tf" # Update accordingly
}

# Creates an ecs service

resource "aws_ecs_service" "own_service" {
  name             = "zmw-svc-tf" # Update accordingly
  cluster          = aws_ecs_cluster.own_cluster.arn
  task_definition  = aws_ecs_task_definition.own_task_definition.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  deployment_circuit_breaker {
    enable          = true
    rollback        = true
  }

  network_configuration {
    subnets          = data.aws_subnets.existing_subnets.ids
    assign_public_ip = true
    security_groups = [var.sg_id]
  }
}