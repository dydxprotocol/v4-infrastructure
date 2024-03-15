resource "datadog_dashboard_json" "comlink" {
  dashboard = <<EOF
{
  "title": "V4 Indexer Comlink",
  "description": "",
  "widgets": [
    {
      "id": 2253178479422500,
      "definition": {
        "title": "Comlink",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 5851150069681238,
            "definition": {
              "title": "CPU Usage - Per Container",
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
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query2"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "max:ecs.fargate.cpu.percent{task_name:*comlink-task,$cluster_name,container_name:*comlink-service-container} by {task_name,container_id}"
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
              ],
              "yaxis": {
                "include_zero": false
              }
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3727308551181742,
            "definition": {
              "title": "Mem Usage - Per Container",
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
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query2"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "max:ecs.fargate.mem.rss{task_name:*comlink-task,$cluster_name,container_name:*comlink-service-container} by {task_name,container_id}"
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
              ],
              "yaxis": {
                "include_zero": false
              }
            },
            "layout": {
              "x": 4,
              "y": 0,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5372651126220702,
            "definition": {
              "title": "Running Instances",
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
                      "query": "min:aws.ecs.service.running{cluster:$cluster_name.value,v4service:comlink} by {v4service}"
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
              "x": 8,
              "y": 0,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 303190507260328,
            "definition": {
              "type": "free_text",
              "text": "Request Handling",
              "color": "#4d4d4d",
              "font_size": "24",
              "text_align": "left"
            },
            "layout": {
              "x": 0,
              "y": 2,
              "width": 12,
              "height": 1
            }
          },
          {
            "id": 7723789610732574,
            "definition": {
              "title": "Comlink API Avg Latency",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "horizontal",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "get_height avg(ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "get_fills avg(ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "get_addresses avg(ms)",
                      "formula": "query4"
                    },
                    {
                      "alias": "get_perp_markets avg(ms)",
                      "formula": "query5"
                    },
                    {
                      "alias": "get_positions avg(ms)",
                      "formula": "query6"
                    },
                    {
                      "alias": "get_trades avg(ms)",
                      "formula": "query7"
                    },
                    {
                      "alias": "get_orderbook avg(ms)",
                      "formula": "query8"
                    },
                    {
                      "alias": "get_candles avg(ms)",
                      "formula": "query9"
                    },
                    {
                      "alias": "get_sparklines avg(ms)",
                      "formula": "query10"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:comlink.height_controller.get_latest_block_height.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:comlink.fills_controller.get_fills.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:comlink.addresses_controller.get_addresses.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "avg:comlink.perpetual_markets_controller.get_perpetual_markets.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query5"
                    },
                    {
                      "query": "avg:comlink.positions_controller.get_positions.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query6"
                    },
                    {
                      "query": "avg:comlink.trades_controller.get_trades.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query7"
                    },
                    {
                      "query": "avg:comlink.orderbook_controller.get_orderbooks.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query8"
                    },
                    {
                      "query": "avg:comlink.candles_controller.get_candles_market.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query9"
                    },
                    {
                      "query": "avg:comlink.sparklines_controller.get_sparklines.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query10"
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
              ],
              "yaxis": {
                "scale": "log",
                "include_zero": false
              }
            },
            "layout": {
              "x": 0,
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 585001811877332,
            "definition": {
              "title": "Comlink API 95% Latency",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "horizontal",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "get_height avg(ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "get_fills 95%(ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "get_addresses 95%(ms)",
                      "formula": "query4"
                    },
                    {
                      "alias": "get_perp_markets 95%(ms)",
                      "formula": "query5"
                    },
                    {
                      "alias": "get_positions 95%(ms)",
                      "formula": "query6"
                    },
                    {
                      "alias": "get_trades 95%(ms)",
                      "formula": "query7"
                    },
                    {
                      "alias": "get_orderbook 95%(ms)",
                      "formula": "query8"
                    },
                    {
                      "alias": "get_candles 95%(ms)",
                      "formula": "query9"
                    },
                    {
                      "alias": "get_candles 95%(ms)",
                      "formula": "query10"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:comlink.height_controller.get_latest_block_height.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:comlink.fills_controller.get_fills.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:comlink.addresses_controller.get_addresses.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "avg:comlink.perpetual_markets_controller.get_perpetual_markets.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query5"
                    },
                    {
                      "query": "avg:comlink.positions_controller.get_positions.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query6"
                    },
                    {
                      "query": "avg:comlink.trades_controller.get_trades.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query7"
                    },
                    {
                      "query": "avg:comlink.orderbook_controller.get_orderbooks.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query8"
                    },
                    {
                      "query": "avg:comlink.candles_controller.get_candles_market.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query9"
                    },
                    {
                      "query": "avg:comlink.sparklines_controller.get_sparklines.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query10"
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
              ],
              "yaxis": {
                "scale": "log",
                "include_zero": false
              }
            },
            "layout": {
              "x": 4,
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1887744464488532,
            "definition": {
              "title": "Comlink API Success Rate",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "horizontal",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "height_controller success rate",
                      "formula": "query1 / query2"
                    },
                    {
                      "alias": "fills_controller success rate",
                      "formula": "query3 / query4"
                    },
                    {
                      "alias": "broadcast_controller success rate",
                      "formula": "query5 / query6"
                    },
                    {
                      "alias": "addr_controller success rate",
                      "formula": "query7 / query8"
                    },
                    {
                      "alias": "perp_market_controller success rate",
                      "formula": "query9 / query10"
                    },
                    {
                      "alias": "perpetual_positions_controller success rate",
                      "formula": "query11 / query12"
                    },
                    {
                      "alias": "trades_controller success rate",
                      "formula": "query13 / query14"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:comlink.height_controller.response_status_code.200{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:comlink.height_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:comlink.fills_controller.response_status_code.200{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:comlink.fills_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "avg:comlink.braodcast_tx_controller.response_status_code.200{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query5"
                    },
                    {
                      "query": "avg:comlink.braodcast_tx_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query6"
                    },
                    {
                      "query": "avg:comlink.addresses_controller.response_status_code.200{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query7"
                    },
                    {
                      "query": "avg:comlink.addresses_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query8"
                    },
                    {
                      "query": "avg:comlink.perpetual_markets_controller.response_status_code.200{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query9"
                    },
                    {
                      "query": "avg:comlink.perpetual_markets_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query10"
                    },
                    {
                      "query": "avg:comlink.perpetual_positions_controller.response_status_code.200{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query11"
                    },
                    {
                      "query": "avg:comlink.perpetual_positions_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query12"
                    },
                    {
                      "query": "avg:comlink.trades_controller.response_status_code.200{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query13"
                    },
                    {
                      "query": "avg:comlink.trades_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query14"
                    }
                  ],
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
              "x": 8,
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4592855879076858,
            "definition": {
              "title": "Comlink API Internal Server Error Rate",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "horizontal",
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
                      "alias": "height_controller ISE rate",
                      "formula": "query1 / query2"
                    },
                    {
                      "alias": "fills_controller ISE rate",
                      "formula": "query3 / query4"
                    },
                    {
                      "alias": "addr_controller ISE rate",
                      "formula": "query7 / query8"
                    },
                    {
                      "alias": "perp_market_controller ISE rate",
                      "formula": "query9 / query10"
                    },
                    {
                      "alias": "perpetual_positions_controller ISE rate",
                      "formula": "query11 / query12"
                    },
                    {
                      "alias": "trades_controller ISE rate",
                      "formula": "query13 / query14"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:comlink.height_controller.response_status_code.500{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:comlink.height_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:comlink.fills_controller.response_status_code.500{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:comlink.fills_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "avg:comlink.addresses_controller.response_status_code.500{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query7"
                    },
                    {
                      "query": "avg:comlink.addresses_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query8"
                    },
                    {
                      "query": "avg:comlink.perpetual_markets_controller.response_status_code.500{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query9"
                    },
                    {
                      "query": "avg:comlink.perpetual_markets_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query10"
                    },
                    {
                      "query": "avg:comlink.perpetual_positions_controller.response_status_code.500{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query11"
                    },
                    {
                      "query": "avg:comlink.perpetual_positions_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query12"
                    },
                    {
                      "query": "avg:comlink.trades_controller.response_status_code.500{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query13"
                    },
                    {
                      "query": "avg:comlink.trades_controller.response_status_code{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query14"
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
              "x": 8,
              "y": 5,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4059636139759006,
            "definition": {
              "title": "Comlink API Call Count",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "horizontal",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "get_height",
                      "formula": "query1"
                    },
                    {
                      "alias": "get_fills",
                      "formula": "query2"
                    },
                    {
                      "alias": "get_addresses",
                      "formula": "query4"
                    },
                    {
                      "alias": "get_perp_markets",
                      "formula": "query5"
                    },
                    {
                      "alias": "get_positions",
                      "formula": "query6"
                    },
                    {
                      "alias": "get_trades",
                      "formula": "query7"
                    },
                    {
                      "alias": "get_orderbook",
                      "formula": "query8"
                    },
                    {
                      "alias": "get_candles",
                      "formula": "query9"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:comlink.height_controller.get_latest_block_height.timing.count{$Environment,$Service}.as_rate()",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:comlink.fills_controller.get_fills.timing.count{$Environment,$Service}.as_rate()",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:comlink.addresses_controller.get_addresses.timing.count{$Environment,$Service}.as_rate()",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "avg:comlink.perpetual_markets_controller.get_perpetual_markets.timing.count{$Environment,$Service}.as_rate()",
                      "data_source": "metrics",
                      "name": "query5"
                    },
                    {
                      "query": "avg:comlink.perpetual_positions_controller.get_perpetual_positions.timing.count{$Environment,$Service}.as_rate()",
                      "data_source": "metrics",
                      "name": "query6"
                    },
                    {
                      "query": "avg:comlink.trades_controller.get_trades.timing.count{$Environment,$Service}.as_rate()",
                      "data_source": "metrics",
                      "name": "query7"
                    },
                    {
                      "query": "avg:comlink.orderbook_controller.get_orderbooks.timing.count{$Environment,$Service}.as_rate()",
                      "data_source": "metrics",
                      "name": "query8"
                    },
                    {
                      "query": "avg:comlink.candles_controller.get_candles_market.timing.count{$Environment,$Service}.as_rate()",
                      "data_source": "metrics",
                      "name": "query9"
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
              ],
              "yaxis": {
                "scale": "linear",
                "include_zero": false
              }
            },
            "layout": {
              "x": 0,
              "y": 5,
              "width": 4,
              "height": 2
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 64,
        "width": 12,
        "height": 8
      }
    }
  ],
  "template_variables": ${jsonencode(local.template_variables)},
  "template_variable_presets": ${jsonencode(local.template_variable_presets)},
  "reflow_type": "fixed",
  "layout_type": "ordered",
  "notify_list": [],
  "tags": [
    "team:v4-indexer"
  ]
}
EOF
}
