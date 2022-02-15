project = "syncldap"

# Labels can be specified for organizational purposes.
labels = { "domaine" = "syncldap" }

runner {
  enabled = true
  data_source "git" {
    ref = var.datacenter
  }
  poll {
    enabled = true
  }
}

# An application to deploy.
app "syncldap" {

  # Build specifies how an application should be deployed.
  build {
        use "docker-pull" {
           image = var.syncldap_name_image_docker
	   tag = var.syncldap_version_image_docker
        }
  }

  # Deploy to Nomad
  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/syncldap.nomad.tpl", {
        datacenter = var.datacenter
        proxy_host = var.proxy_host
        proxy_port = var.proxy_port
		cpu = var.cpu
		memory = var.memory
      })
    }
  }
}

variable "datacenter" {
  type    = string
  default = "dc1"
}

variable "dockerfile_path" {
  type = string
  default = "Dockerfile"
}

variable "registry_path" {
  type = string
  default = "registry.repo.proxy-dev-forge.asip.hst.fluxus.net/ans"
}

variable "proxy_host" {
  type = string
  default = ""
}

variable "proxy_port" {
  type = string
  default = ""
}

variable "cpu" {
  type = string
  default = "5000"
}

variable "memory" {
  type = string
  default = "2048"
}

variable "syncldap_name_image_docker" {
  type = string
  default = "ans/syncldap"
}

variable "syncldap_version_image_docker" {
  type = string
  default = "1.0.0"
}
