/*
resource "datadog_dashboard_json" "indexer" {
  dashboard = <<EOF
{
  "title": "V4 Indexer Overall",
  "description": "",
  "widgets": [
  ],
  "template_variables": [
    {
      "name": "Environment",
      "prefix": "env",
      "available_values": [],
      "default": "*"
    },
    {
      "name": "Service",
      "prefix": "service",
      "available_values": [],
      "default": "indexer"
    },
    {
      "name": "ecs_task_family",
      "prefix": "ecs_task_family",
      "available_values": [],
      "default": "*"
    },
    {
      "name": "container_name",
      "prefix": "container_name",
      "available_values": [],
      "default": "*"
    },
    {
      "name": "region",
      "prefix": "region",
      "available_values": [],
      "default": "*"
    },
    {
      "name": "cluster_name",
      "prefix": "cluster_name",
      "available_values": [
        "testnet-indexer-apne1-cluster",
        "staging-indexer-apne1-cluster",
        "dev-indexer-apne1-cluster",
        "dev-indexer-apne1-msk-cluster",
        "testnet-indexer-apne1-msk-cluster",
        "staging-indexer-apne1-msk-cluster",
        "dev2-indexer-apne1-cluster",
        "dev3-indexer-apne1-cluster",
        "dev4-indexer-apne1-cluster",
        "dev5-indexer-apne1-cluster",
        "testnet1-indexer-apne1-cluster"
      ],
      "default": "dev-indexer-apne1-cluster"
    },
    {
      "name": "task_name",
      "prefix": "task_name",
      "available_values": [],
      "default": "*"
    },
    {
      "name": "project",
      "prefix": "project",
      "available_values": [],
      "default": "v4"
    },
    {
      "name": "ecs_cluster_name",
      "prefix": "ecs_cluster_name",
      "available_values": [
        "testnet-indexer-full-node-cluster",
        "dev-indexer-full-node-cluster",
        "staging-indexer-full-node-cluster",
        "dev4-indexer-full-node-cluster",
        "dev2-indexer-full-node-cluster",
        "dev3-indexer-full-node-cluster",
        "dev5-indexer-full-node-cluster",
        "testnet1-indexer-full-node-cluster"
      ],
      "default": "dev-indexer-full-node-cluster"
    },
    {
      "name": "cluster",
      "prefix": "cluster",
      "available_values": [
        "dev-indexer-apne1-cluster",
        "staging-indexer-apne1-cluster",
        "testnet-indexer-apne1-cluster",
        "dev2-indexer-apne1-cluster",
        "dev3-indexer-apne1-cluster",
        "dev4-indexer-apne1-cluster",
        "dev5-indexer-apne1-cluster",
        "testnet1-indexer-apne1-cluster"
      ],
      "default": "dev-indexer-apne1-cluster"
    },
    {
      "name": "msk_cluster_name",
      "prefix": "cluster_name",
      "available_values": [
        "dev-indexer-apne1-msk-cluster",
        "staging-indexer-apne1-msk-cluster",
        "testnet-indexer-apne1-msk-cluster",
        "dev2-indexer-apne1-msk-cluster",
        "dev3-indexer-apne1-msk-cluster",
        "dev4-indexer-apne1-msk-cluster",
        "dev5-indexer-apne1-msk-cluster",
        "testnet1-indexer-apne1-msk-cluster"
      ],
      "default": "*"
    }
  ],
  "layout_type": "ordered",
  "notify_list": [],
  "template_variable_presets": [
    {
      "name": "dev",
      "template_variables": [
        {
          "name": "Environment",
          "value": "dev"
        },
        {
          "name": "Service",
          "value": "indexer"
        },
        {
          "name": "ecs_task_family",
          "value": "*"
        },
        {
          "name": "container_name",
          "value": "*"
        },
        {
          "name": "region",
          "value": "*"
        },
        {
          "name": "task_name",
          "value": "*"
        },
        {
          "name": "project",
          "value": "v4"
        },
        {
          "name": "ecs_cluster_name",
          "value": "*"
        },
        {
          "name": "msk_cluster_name",
          "value": "dev-indexer-apne1-msk-cluster"
        }
      ]
    },
    {
      "name": "dev2",
      "template_variables": [
        {
          "name": "Environment",
          "value": "dev2"
        },
        {
          "name": "Service",
          "value": "indexer"
        },
        {
          "name": "ecs_task_family",
          "value": "*"
        },
        {
          "name": "container_name",
          "value": "*"
        },
        {
          "name": "region",
          "value": "*"
        },
        {
          "name": "cluster_name",
          "value": "dev2-indexer-apne1-cluster"
        },
        {
          "name": "task_name",
          "value": "*"
        },
        {
          "name": "project",
          "value": "v4"
        },
        {
          "name": "ecs_cluster_name",
          "value": "*"
        },
        {
          "name": "cluster",
          "value": "dev2-indexer-apne1-cluster"
        },
        {
          "name": "msk_cluster_name",
          "value": "dev2-indexer-apne1-msk-cluster"
        }
      ]
    },
    {
      "name": "dev3",
      "template_variables": [
        {
          "name": "Environment",
          "value": "dev3"
        },
        {
          "name": "Service",
          "value": "indexer"
        },
        {
          "name": "ecs_task_family",
          "value": "*"
        },
        {
          "name": "container_name",
          "value": "*"
        },
        {
          "name": "region",
          "value": "*"
        },
        {
          "name": "cluster_name",
          "value": "dev3-indexer-apne1-cluster"
        },
        {
          "name": "task_name",
          "value": "*"
        },
        {
          "name": "project",
          "value": "v4"
        },
        {
          "name": "ecs_cluster_name",
          "value": "*"
        },
        {
          "name": "cluster",
          "value": "dev3-indexer-apne1-cluster"
        },
        {
          "name": "msk_cluster_name",
          "value": "dev3-indexer-apne1-msk-cluster"
        }
      ]
    },
    {
      "name": "dev4",
      "template_variables": [
        {
          "name": "Environment",
          "value": "dev4"
        },
        {
          "name": "Service",
          "value": "indexer"
        },
        {
          "name": "ecs_task_family",
          "value": "*"
        },
        {
          "name": "container_name",
          "value": "*"
        },
        {
          "name": "region",
          "value": "*"
        },
        {
          "name": "cluster_name",
          "value": "dev4-indexer-apne1-cluster"
        },
        {
          "name": "task_name",
          "value": "*"
        },
        {
          "name": "project",
          "value": "v4"
        },
        {
          "name": "ecs_cluster_name",
          "value": "*"
        },
        {
          "name": "cluster",
          "value": "dev4-indexer-apne1-cluster"
        },
        {
          "name": "msk_cluster_name",
          "value": "dev4-indexer-apne1-msk-cluster"
        }
      ]
    },
    {
      "name": "dev5",
      "template_variables": [
        {
          "name": "Environment",
          "value": "dev5"
        },
        {
          "name": "Service",
          "value": "indexer"
        },
        {
          "name": "ecs_task_family",
          "value": "*"
        },
        {
          "name": "container_name",
          "value": "*"
        },
        {
          "name": "region",
          "value": "*"
        },
        {
          "name": "cluster_name",
          "value": "dev5-indexer-apne1-cluster"
        },
        {
          "name": "task_name",
          "value": "*"
        },
        {
          "name": "project",
          "value": "v4"
        },
        {
          "name": "ecs_cluster_name",
          "value": "*"
        },
        {
          "name": "cluster",
          "value": "dev5-indexer-apne1-cluster"
        },
        {
          "name": "msk_cluster_name",
          "value": "dev5-indexer-apne1-msk-cluster"
        }
      ]
    },
    {
      "name": "staging",
      "template_variables": [
        {
          "name": "Environment",
          "value": "staging"
        },
        {
          "name": "Service",
          "value": "indexer"
        },
        {
          "name": "ecs_task_family",
          "value": "*"
        },
        {
          "name": "container_name",
          "value": "*"
        },
        {
          "name": "region",
          "value": "*"
        },
        {
          "name": "cluster_name",
          "value": "staging-indexer-apne1-cluster"
        },
        {
          "name": "task_name",
          "value": "*"
        },
        {
          "name": "project",
          "value": "v4"
        },
        {
          "name": "ecs_cluster_name",
          "value": "staging-indexer-full-node-cluster"
        },
        {
          "name": "cluster",
          "value": "staging-indexer-apne1-cluster"
        },
        {
          "name": "msk_cluster_name",
          "value": "staging-indexer-apne1-msk-cluster"
        }
      ]
    },
    {
      "name": "testnet2 (Public)",
      "template_variables": [
        {
          "name": "Environment",
          "value": "testnet2"
        },
        {
          "name": "Service",
          "value": "indexer"
        },
        {
          "name": "ecs_task_family",
          "value": "*"
        },
        {
          "name": "container_name",
          "value": "*"
        },
        {
          "name": "region",
          "value": "*"
        },
        {
          "name": "cluster_name",
          "value": "testnet2-indexer-apne1-cluster"
        },
        {
          "name": "task_name",
          "value": "*"
        },
        {
          "name": "project",
          "value": "v4"
        },
        {
          "name": "ecs_cluster_name",
          "value": "testnet2-indexer-full-node-cluster"
        },
        {
          "name": "cluster",
          "value": "testnet2-indexer-apne1-cluster"
        },
        {
          "name": "msk_cluster_name",
          "value": "testnet2-indexer-apne1-msk-cluster"
        }
      ]
    }
  ],
  "reflow_type": "fixed",
  "tags": [
    "team:v4-indexer"
  ]
}
EOF
}
*/
