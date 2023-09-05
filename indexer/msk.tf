resource "aws_msk_configuration" "main" {
  kafka_versions    = [local.kafka_version]
  name              = "${var.environment}-${var.indexers[var.region].name}-msk-configuration"
  server_properties = <<PROPERTIES
  auto.create.topics.enable=false
  default.replication.factor=3
  min.insync.replicas=2
  num.io.threads=8
  num.network.threads=5
  num.partitions=1
  num.replica.fetchers=2
  replica.lag.time.max.ms=30000
  socket.receive.buffer.bytes=102400
  socket.request.max.bytes=104857600
  socket.send.buffer.bytes=102400
  replica.fetch.max.bytes=4194304
  message.max.bytes=4194304
  unclean.leader.election.enable=true
  zookeeper.session.timeout.ms=18000
  PROPERTIES
}

resource "aws_msk_cluster" "main" {
  cluster_name           = "${var.environment}-${var.indexers[var.region].name}-msk-cluster"
  kafka_version          = local.kafka_version
  number_of_broker_nodes = 3
  broker_node_group_info {
    instance_type = var.msk_instance_type
    storage_info {
      ebs_storage_info {
        volume_size = 1000 # in GB
      }
    }
    client_subnets = [
      for subnet in aws_subnet.private_subnets : subnet.id
    ]
    security_groups = [aws_security_group.msk.id]
  }

  encryption_info {
    encryption_in_transit {
      # PLAINTEXT is necessary for msk to populate the bootstrap_brokers property
      client_broker = "PLAINTEXT"
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.main.arn
    revision = aws_msk_configuration.main.latest_revision
  }
}
