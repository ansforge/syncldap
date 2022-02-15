job "syncldap" {
  datacenters = ["${datacenter}"]
  type = "batch"
  periodic {
    cron             = "*/15 * * * * *"
    prohibit_overlap = true
  }
  vault {
    policies = ["rhodecode"]
    change_mode = "restart"
  }
  group "syncldap" {
    task "syncldap" {
      driver = "docker"
      config {
        image = "${syncldap_name_image_docker}:${syncldap_version_image_docker}"
      }
      template {
        data = <<EOH
LDAP_BIND_DN="{{with secret "rhodecode/ldap"}}{{.Data.data.bind_dn}}{{end}}"
LDAP_BIND_PASSWORD="{{with secret "rhodecode/ldap"}}{{.Data.data.bind_password}}{{end}}"
LDAP_URL="{{with secret "rhodecode/ldap"}}{{.Data.data.url}}{{end}}"
RHODECODE_AUTH_TOKEN="{{with secret "rhodecode/api"}}{{.Data.data.auth_token}}{{end}}"
{{range service ("rhodecode-rhodecode") }}RHODECODE_API_URL="http://{{.Address}}:{{.Port}}/_admin/api"{{end}}
        EOH
        destination = "secrets/file.env"
        change_mode = "restart"
        env         = true
     }
      resources {
        cpu    = ${cpu}
        memory = ${memory}
      }
    }
  }
}
