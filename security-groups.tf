resource "yandex_vpc_security_group" "web_sg" {
  name        = "web-servers-sg"
  description = "Allow HTTP (80) and SSH (22)"
  network_id  = var.network_id

  ingress {
    description = "HTTP from anywhere"
    protocol    = "TCP"
    port        = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere (use your IP in prod!)"
    protocol    = "TCP"
    port        = 22
    v4_cidr_blocks = ["0.0.0.0/0"]  # для теста; в продакшене — ваш IP
  }

  egress {
    description = "Any outbound traffic"
    protocol    = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
