resource "datadog_dashboard_json" "roundtable" {
  dashboard = <<EOF
{
  "title": "V4 Indexer Roundtable",
  "description": "",
  "widgets": [
    {
      "id": 3704865606287398,
      "definition": {
        "title": "Roundtable",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 3854037923215042,
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
                      "query": "max:ecs.fargate.cpu.percent{task_name:*roundtable-task,$cluster_name,container_name:*roundtable-service-container} by {task_name,container_id}"
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
            "id": 1083112124540652,
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
                      "query": "max:ecs.fargate.mem.rss{task_name:*roundtable-task,$cluster_name,container_name:*roundtable-service-container} by {task_name,container_id}"
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
            "id": 1153755667830218,
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
                      "query": "min:aws.ecs.service.running{cluster:$cluster_name.value,v4service:roundtable}"
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
            "id": 6571746955570588,
            "definition": {
              "type": "free_text",
              "text": "Tasks",
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
            "id": 7729639252558346,
            "definition": {
              "title": "Roundtable Market Updater Loop Completion Ratio",
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
                      "alias": "market updater success ratio",
                      "formula": "query2 / query1"
                    },
                    {
                      "alias": "compute pnl success ratio",
                      "formula": "query3 / query4"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.market_updater.completed{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.loops.market_updater.started{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.loops.create_pnl_ticks.completed{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:roundtable.loops.create_pnl_ticks.started{$Environment,$Service}",
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
              ]
            },
            "layout": {
              "x": 0,
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4533400894838476,
            "definition": {
              "title": "",
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
                      "alias": "Market Updater Loop Avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "Market Updater Loop 95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Market Updater Loop Max (ms)",
                      "formula": "query3"
                    },
                    {
                      "alias": "Get Fills Avg (ms)",
                      "formula": "query4"
                    },
                    {
                      "alias": "Market Updater Timing Avg (ms)",
                      "formula": "query5"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.market_updater.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.loops.market_updater.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.loops.market_updater.timing.max{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:roundtable.markets_updater_get_fills_positions_and_markets_timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "avg:roundtable.market_updater_update_timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query5"
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
              "x": 4,
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1086754073342310,
            "definition": {
              "title": "Create Pnl Ticks Task Latency",
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
                      "alias": "Create Pnl Ticks Loop Avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "Create Pnl Ticks Loop 95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Create Pnl Ticks Loop Max (ms)",
                      "formula": "query3"
                    },
                    {
                      "alias": "Create Pnl Ticks Timing Avg (ms)",
                      "formula": "query4"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.create_pnl_ticks.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.loops.create_pnl_ticks.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.loops.create_pnl_ticks.timing.max{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:roundtable_generate_ticks_timing.avg{$Environment,$Service}",
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
            "id": 1627630683167724,
            "definition": {
              "title": "Roundtable Locking and Concurrency Stats",
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
                      "formula": "query2"
                    },
                    {
                      "formula": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.exceeded_max_concurrent_tasks{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.loops.could_not_acquire_extended_lock{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query1"
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
              "x": 0,
              "y": 5,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5159327596208808,
            "definition": {
              "title": "Roundtable publishToMarketsWebsocket stats",
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
                      "alias": "Avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Max (ms)",
                      "formula": "query3"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:roundtable.publish_markets_websocket_updates_duration.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.publish_markets_websocket_updates_duration.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.publish_markets_websocket_updates_duration.max{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query3"
                    }
                  ],
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                },
                {
                  "formulas": [
                    {
                      "formula": "query0",
                      "style": {
                        "palette_index": 4,
                        "palette": "green"
                      }
                    }
                  ],
                  "response_format": "timeseries",
                  "on_right_yaxis": true,
                  "queries": [
                    {
                      "query": "avg:roundtable.publish_markets_websocket_updates_duration.count{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query0"
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
              "x": 4,
              "y": 5,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3676577945587352,
            "definition": {
              "title": "Roundtable Loop Duration Ratio (Interval of 10s)",
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
                      "formula": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.duration_ratio{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
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
              "y": 5,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 7560792979630466,
            "definition": {
              "title": "Delete Zero Levels Task Latency",
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
                      "alias": "Delete Zero Levels Loop Avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "Delete Zero Levels Loop 95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Delete Zero Levels Loop Max (ms)",
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.delete_zero_price_levels.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.loops.delete_zero_price_levels.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.loops.delete_zero_price_levels.timing.max{$Environment,$Service}",
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
                },
                {
                  "on_right_yaxis": true,
                  "formulas": [
                    {
                      "alias": "Num Zero Levels Deleted",
                      "formula": "query0"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query0",
                      "query": "avg:roundtable.delete_zero_price_levels.num_levels_deleted{$Environment,$Service}"
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
              ]
            },
            "layout": {
              "x": 0,
              "y": 7,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 7888562347332680,
            "definition": {
              "title": "Expire Orders Task Latency",
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
                      "alias": "Remove Expired Orders Loop Avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "Remove Expired Orders Loop 95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Remove Expired Orders Loop Max (ms)",
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.remove_expired_orders.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.loops.remove_expired_orders.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.loops.remove_expired_orders.timing.max{$Environment,$Service}",
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
                },
                {
                  "on_right_yaxis": true,
                  "formulas": [
                    {
                      "alias": "Expire Messages sent",
                      "formula": "query0"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query0",
                      "query": "avg:roundtable.expiry_message_sent{$Environment,$Service}.as_count()"
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
              ]
            },
            "layout": {
              "x": 4,
              "y": 7,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1723944386631222,
            "definition": {
              "title": "Cancel Stale Orders Task Latency",
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
                      "alias": "Cancel Stale Orders Loop Avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "Cancel Stale Orders Loop 95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Cancel Stale Orders Loop Max (ms)",
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.cancel_stale_orders.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.loops.cancel_stale_orders.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.loops.cancel_stale_orders.timing.max{$Environment,$Service}",
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
                },
                {
                  "on_right_yaxis": true,
                  "formulas": [
                    {
                      "alias": "Num Stale Orders Canceled",
                      "formula": "query0"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query0",
                      "query": "avg:roundtable.num_stale_orders_canceled.count{$Environment,$Service}"
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
              ]
            },
            "layout": {
              "x": 8,
              "y": 7,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3626710840643786,
            "definition": {
              "title": "Update Research Environment Task Latency",
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
                      "alias": "Update Research Environment Loop Avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "Update Research Environment Loop 95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Update Research Environment Loop Max (ms)",
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:roundtable.loops.update_research_environment.timing.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:roundtable.loops.update_research_environment.timing.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:roundtable.loops.update_research_environment.timing.max{$Environment,$Service}",
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
              ]
            },
            "layout": {
              "x": 0,
              "y": 9,
              "width": 4,
              "height": 2
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 63,
        "width": 12,
        "height": 1,
        "is_column_break": true
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
