variable "REPOSITORY_URI" {
  type = string
}

resource "aws_lightsail_container_service" "flask_application" {
  name  = "flask-app"
  power = "nano"
  scale = 1

  private_registry_access {
    ecr_image_puller_role {
      is_active = true
    }
  }

  tags = {
    version = "1.0.0"
  }
}

resource "aws_lightsail_container_service_deployment_version" "flask_app_deployment" {
  container {
    container_name = "flask-application"
    image          = "${var.REPOSITORY_URI}:latest"
  }

  ports = {
    80 = "HTTP"
  }

  public_endpoint {
    container_name = "flask-application"
    container_port = 8080

    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout_seconds     = 2
      interval_seconds    = 10
      path                = "/"
      success_codes       = "200-499"
    }
  }
  
  service_name = aws_lightsail_container_service.flask_application.name
  
}
