output "lb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "listener_arn" {
  value = var.name == "public" ? aws_lb_listener.listener[0].arn : aws_lb_listener.private[0].arn
}