# Create a target group from hosts with load balancer applications

# Using the dynamic block "target" and the for_each meta-argument
# https://www.terraform.io/docs/configuration/expressions.html#dynamic-blocks
# https://www.terraform.io/docs/configuration/resources.html#for_each-multiple-resource-instances-defined-by-a-map-or-set-of-strings

resource "yandex_lb_target_group" "reddit-app-group" {
    name = "reddit-app-group"

    dynamic "target" {
        for_each = yandex_compute_instance.app.*.network_interface.0.ip_address
        content {
            subnet_id = var.subnet_id
            address = target.value
        }

    }
}

# Сreate a load balancer that listens on port 80 and redirects traffic to port 9292 of available instances

resource "yandex_lb_network_load_balancer" "lb-reddit-app" {
    name = "lb-reddit-app"

    listener {
        name = "listener-for-puma"
        port = 80
        target_port = 9292
        external_address_spec {
            ip_version = "ipv4"
        }
    }

    attached_target_group {
        target_group_id = yandex_lb_target_group.reddit-app-group.id

        healthcheck {
            name = "http"
            http_options {
                port = 9292
                path = "/"
            }
        }
    }
}
