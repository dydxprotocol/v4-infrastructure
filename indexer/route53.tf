resource "aws_route53_zone" "main" {
  name = "dydx-indexer.private"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "read_replica_1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "postgres-main-rr.dydx-indexer.private"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_db_instance.read_replica.address}"]
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = "read_replica_1"
}

resource "aws_route53_record" "read_replica_2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "postgres-main-rr.dydx-indexer.private"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_db_instance.read_replica_2.address}"]
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = "read_replica_2"
}
