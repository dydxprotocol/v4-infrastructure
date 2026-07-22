resource "aws_route53_zone" "main" {
  count = local.indexer_enabled ? 1 : 0
  name  = "dydx-indexer.private"

  vpc {
    vpc_id = aws_vpc.main[0].id
  }
}

resource "aws_route53_record" "read_replica_1" {
  count   = local.indexer_enabled && var.create_read_replica ? 1 : 0
  zone_id = aws_route53_zone.main[0].zone_id
  name    = "postgres-main-rr.dydx-indexer.private"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_db_instance.read_replica[count.index].address}"]
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = "read_replica_1"
}

resource "aws_route53_record" "read_replica_2" {
  count   = local.indexer_enabled && var.create_read_replica_2 ? 1 : 0
  zone_id = aws_route53_zone.main[0].zone_id
  name    = "postgres-main-rr.dydx-indexer.private"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_db_instance.read_replica_2[count.index].address}"]
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = "read_replica_2"
}
