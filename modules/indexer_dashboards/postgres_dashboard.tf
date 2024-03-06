resource "datadog_dashboard_json" "postgres" {
  dashboard = <<EOF
{
  "title": "V4 Indexer Postgres",
  "description": null,
  "widgets": [
    {
      "id": 8395172130666522,
      "definition": {
        "title": "RDS Replica Lag",
        "title_size": "16",
        "title_align": "left",
        "show_legend": true,
        "legend_layout": "auto",
        "legend_columns": [
          "avg",
          "min",
          "max",
          "value",
          "sum"
        ],
        "time": {},
        "type": "timeseries",
        "requests": [
          {
            "formulas": [
              {
                "formula": "query1"
              }
            ],
            "queries": [
              {
                "name": "query1",
                "data_source": "metrics",
                "query": "avg:aws.rds.replica_lag{environment:$Environment.value,name:*-indexer-apne1-db-read-replica}"
              }
            ],
            "response_format": "timeseries",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 4,
        "height": 2
      }
    }
  ],
  "template_variables": ${jsonencode(local.template_variables)},
  "template_variable_presets": ${jsonencode(local.template_variable_presets)},
  "layout_type": "ordered",
  "notify_list": [],
  "reflow_type": "fixed",
  "tags": [
    "team:v4-indexer"
  ]
}
EOF
}
