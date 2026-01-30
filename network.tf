resource "yandex_lb_target_group" "web_tg" {
  name = "web-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.web_servers
    content {
      address   = target.value.network_interface[0].ip_address  # явно берём первый интерфейс
      subnet_id = var.subnet_id
    }
  }
}

resource "yandex_lb_network_load_balancer" "nlb" {
  name  = "web-nlb"

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 80
    protocol    = "tcp"
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web_tg.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
      interval       = 5
      timeout        = 3
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }
}
