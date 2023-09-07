resource "datadog_dashboard_json" "full_node" {
  dashboard = <<EOF
{
  "title": "V4 Indexer Full node",
  "description": "",
  "widgets": [
    {
      "id": 3627505918109706,
      "definition": {
        "title": "V4 Full Node",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 4389905702208102,
            "definition": {
              "title": "Send Off-chain Data Latency",
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
                      "alias": "latency (ms)",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:dydxprotocol.send_offchain_data_latency.quantile{$ecs_cluster_name} by {quantile}",
                      "data_source": "metrics",
                      "name": "query1"
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
                "include_zero": false,
                "scale": "log"
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
            "id": 5175223202514392,
            "definition": {
              "title": "Send Off-chain Data Count",
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
                      "alias": "success",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "sum:dydxprotocol.msgsender_message_send_success.count{$ecs_cluster_name}.as_count()",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "bars"
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
            "id": 2065638610961772,
            "definition": {
              "title": "BTC Orderbook Best Bid / Ask (Indexer vs Full-Node)",
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
                      "alias": "Indexer Best Ask",
                      "formula": "query1"
                    },
                    {
                      "alias": "Indexer Best Bid",
                      "formula": "query2"
                    },
                    {
                      "alias": "Full Node Best Bid",
                      "formula": "query3"
                    },
                    {
                      "alias": "Full Node Best Ask",
                      "formula": "query4"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_ask_subticks{$Environment,clob_pair_id:0}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_bid_subticks{$Environment,clob_pair_id:0}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_bid_clob_pair{$Environment,clob_pair_id:0,$ecs_cluster_name}",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_ask_clob_pair{$Environment,clob_pair_id:0,$ecs_cluster_name}",
                      "data_source": "metrics",
                      "name": "query4"
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
              "x": 8,
              "y": 0,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4200226330250326,
            "definition": {
              "title": "ETH Orderbook Best Bid / Ask (Indexer vs Full-Node)",
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
                      "alias": "Indexer Best Ask",
                      "formula": "query1"
                    },
                    {
                      "alias": "Indexer Best Bid",
                      "formula": "query2"
                    },
                    {
                      "alias": "Full Node Best Bid",
                      "formula": "query3"
                    },
                    {
                      "alias": "Full Node Best Ask",
                      "formula": "query4"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_ask_subticks{$Environment,clob_pair_id:1}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_bid_subticks{$Environment,clob_pair_id:1}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_bid_clob_pair{$Environment,clob_pair_id:1,$ecs_cluster_name}",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_ask_clob_pair{$Environment,clob_pair_id:1,$ecs_cluster_name}",
                      "data_source": "metrics",
                      "name": "query4"
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
              "y": 2,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4965251786604264,
            "definition": {
              "title": "% Difference for Best Bid (Indexer vs Full-Node)",
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
                      "formula": "abs(((query2 - query3) / query2) * 100)"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_bid_subticks{$Environment} by {clob_pair_id}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_bid_clob_pair{$Environment,$ecs_cluster_name} by {clob_pair_id}",
                      "data_source": "metrics",
                      "name": "query3"
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
              "y": 2,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1872936273501168,
            "definition": {
              "title": "% Difference for Best Ask (Indexer vs Full-Node)",
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
                      "formula": "abs(((query2 - query3) / query2) * 100)"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_ask_subticks{$Environment} by {clob_pair_id}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_ask_clob_pair{$Environment , $ecs_cluster_name} by {clob_pair_id}",
                      "data_source": "metrics",
                      "name": "query3"
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
              "x": 8,
              "y": 2,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 2662411043829594,
            "definition": {
              "title": "ETH Orderbook Spread (Indexer vs Full-Node)",
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
                      "alias": "Indexer Spread",
                      "formula": "query1 - query2"
                    },
                    {
                      "alias": "Full Node Spread",
                      "formula": "query4 - query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_ask_subticks{$Environment,clob_pair_id:1}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_bid_subticks{$Environment,clob_pair_id:1}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_ask_clob_pair{$Environment,clob_pair_id:1,$ecs_cluster_name}",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_bid_clob_pair{$Environment,clob_pair_id:1,$ecs_cluster_name}",
                      "data_source": "metrics",
                      "name": "query3"
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
              "y": 4,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5242619265899866,
            "definition": {
              "title": "BTC Orderbook Spread (Indexer vs Full-Node)",
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
                      "alias": "Indexer Spread",
                      "formula": "query1 - query2"
                    },
                    {
                      "alias": "Full Node Spread",
                      "formula": "query4 - query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_ask_subticks{$Environment,clob_pair_id:0}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.crossed_orderbook.best_bid_subticks{$Environment,clob_pair_id:0}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_ask_clob_pair{$Environment,clob_pair_id:0,$ecs_cluster_name}",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "avg:dydxprotocol.clob_best_bid_clob_pair{$Environment,clob_pair_id:0,$ecs_cluster_name}",
                      "data_source": "metrics",
                      "name": "query3"
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
              "y": 4,
              "width": 4,
              "height": 2
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 87,
        "width": 12,
        "height": 7
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
