resource "datadog_dashboard_json" "vulcan" {
  dashboard = <<EOF
{
  "title": "V4 Indexer Vulcan",
  "description": "",
  "widgets": [
    {
      "id": 3519142303443504,
      "definition": {
        "title": "Vulcan",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 4990642480582282,
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
                      "query": "max:ecs.fargate.cpu.percent{task_name:*vulcan-task,$cluster_name,container_name:*vulcan-service-container} by {task_name,container_id}"
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
            "id": 5535428031972446,
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
                      "query": "max:ecs.fargate.mem.rss{task_name:*vulcan-task,$cluster_name,container_name:*vulcan-service-container} by {task_name,container_id}"
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
            "id": 2143842224796494,
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
                      "query": "min:aws.ecs.service.running{cluster:$cluster_name.value,v4service:vulcan}"
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
          }
        ]
      }
    },
    {
      "id": 3519142303443504,
      "definition": {
        "title": "Kafka",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 5790017990948222,
            "definition": {
              "title": "Max Offset Lag",
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
                      "query": "max:aws.kafka.max_offset_lag{consumer_group:vulcan,$msk_cluster_name}"
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
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8713395057313654,
            "definition": {
              "title": "Message Time In Queue",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "max:vulcan.message_time_in_queue.avg{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "max:vulcan.message_time_in_queue.95percentile{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "max:vulcan.message_time_in_queue.max{$Environment,$Service,$cluster_name}"
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
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1289757450147340,
            "definition": {
              "title": "Message Stats",
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
                      "alias": "total msgs received in last min",
                      "style": {
                        "palette_index": 1,
                        "palette": "classic"
                      },
                      "formula": "query1"
                    },
                    {
                      "alias": "empty msgs received in last min",
                      "style": {
                        "palette_index": 4,
                        "palette": "warm"
                      },
                      "formula": "query2"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:vulcan.received_kafka_message{$Environment,$Service}.as_count().rollup(sum, 60)",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:vulcan.empty_kafka_message{$Environment,$Service}.rollup(sum, 60)",
                      "data_source": "metrics",
                      "name": "query2"
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
          }
        ]
      }
    },
    {
      "id": 3519142303443504,
      "definition": {
        "title": "Processing Metrics",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 7986094966409234,
            "definition": {
              "title": "Overall Timing Per Update",
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
                      "formula": "query3"
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query2"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.max{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.avg{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.95percentile{$Environment,$Service,$cluster_name}"
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
              "y": 6,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5529526737223540,
            "definition": {
              "title": "Overall Count of Updates",
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
                      "query": "sum:vulcan.processed_update.timing.count{$Environment,$Service,$cluster_name}.as_count()"
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
              "y": 6,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5214425847715280,
            "definition": {
              "title": "Total Time Spent Per Update Type",
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
                      "formula": "query1 * query2"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.avg{$Environment,$Service,$cluster_name} by {messagetype}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "sum:vulcan.processed_update.timing.count{$Environment,$Service,$cluster_name} by {messagetype}.as_count()"
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
              "x": 8,
              "y": 6,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8097913084238316,
            "definition": {
              "title": "Flush websocket latency",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.flush_websocket.timing.avg{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.flush_websocket.timing.95percentile{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.flush_websocket.timing.max{$Environment,$Service,$cluster_name}"
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
              "y": 8,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5162583186058608,
            "definition": {
              "title": "Flush websocket message batch size",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.flush_websocket.size.avg{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.flush_websocket.size.95percentile{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.flush_websocket.size.max{$Environment,$Service,$cluster_name}"
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
              "y": 8,
              "width": 4,
              "height": 2
            }
          }
        ]
      }
    },
    {
      "id": 3519142303443504,
      "definition": {
        "title": "Order Place",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 1327422510394566,
            "definition": {
              "title": "Order Place Timing",
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
                    },
                    {
                      "formula": "query2"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.avg{$Environment,$Service,$cluster_name,messagetype:orderplace}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.95percentile{$Environment,$Service,$cluster_name,messagetype:orderplace}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.max{$Environment,$Service,$cluster_name,messagetype:orderplace}"
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
              "y": 11,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8026213644553916,
            "definition": {
              "title": "Order Place Count",
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
                      "query": "sum:vulcan.processed_update.timing.count{$Environment,$Service,$cluster_name,messagetype:orderplace}.as_count()"
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
              "y": 11,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 7322186465820558,
            "definition": {
              "title": "Update Order Cache Timing",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.avg{$Environment,$Service,$cluster_name,classname:orderplacehandler,fnname:place_order_cache_update}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.95percentile{$Environment,$Service,$cluster_name,classname:orderplacehandler,fnname:place_order_cache_update}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.max{$Environment,$Service,$cluster_name,classname:orderplacehandler,fnname:place_order_cache_update}"
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
              "x": 8,
              "y": 11,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8541277752606820,
            "definition": {
              "title": "Update Orderbook Levels Cache Timing",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.avg{$Environment,$Service,$cluster_name,classname:orderplacehandler,fnname:update_price_level}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.95percentile{$Environment,$Service,$cluster_name,classname:orderplacehandler,fnname:update_price_level}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.max{$Environment,$Service,$cluster_name,classname:orderplacehandler,fnname:update_price_level}"
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
              "y": 13,
              "width": 4,
              "height": 2
            }
          }
        ]
      }
    },
    {
      "id": 3519142303443504,
      "definition": {
        "title": "Order Remove",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 8622086620358788,
            "definition": {
              "title": "Order Remove Timing",
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
                    },
                    {
                      "formula": "query2"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.avg{$Environment,$Service,$cluster_name,messagetype:orderremove}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.95percentile{$Environment,$Service,$cluster_name,messagetype:orderremove}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.max{$Environment,$Service,$cluster_name,messagetype:orderremove}"
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
              "y": 16,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5036382829855140,
            "definition": {
              "title": "Order Remove Count",
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
                      "query": "sum:vulcan.processed_update.timing.count{$Environment,$Service,$cluster_name,messagetype:orderremove}.as_count()"
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
              "y": 16,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8098893349382624,
            "definition": {
              "title": "Update Order Cache Timing",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.avg{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:remove_order}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.95percentile{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:remove_order}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.max{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:remove_order}"
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
              "x": 8,
              "y": 16,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 2943131632021642,
            "definition": {
              "title": "Update Postgres Timing",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.avg{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:cancel_order_in_postgres}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.95percentile{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:cancel_order_in_postgres}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.max{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:cancel_order_in_postgres}"
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
              "y": 18,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1521543023370678,
            "definition": {
              "title": "Update Orderbook Levels Cache Timing",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.avg{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:update_price_level_cache}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.95percentile{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:update_price_level_cache}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.max{$Environment,$Service,$cluster_name,classname:orderremovehandler,fnname:update_price_level_cache}"
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
              "x": 4,
              "y": 18,
              "width": 4,
              "height": 2
            }
          }
        ]
      }
    },
    {
      "id": 3519142303443504,
      "definition": {
        "title": "Order Update",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 1718743095879270,
            "definition": {
              "title": "Order Update Timing",
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
                    },
                    {
                      "formula": "query2"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.avg{$Environment,$Service,$cluster_name,messagetype:orderupdate}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.95percentile{$Environment,$Service,$cluster_name,messagetype:orderupdate}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.processed_update.timing.max{$Environment,$Service,$cluster_name,messagetype:orderupdate}"
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
              "y": 21,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8439377482246760,
            "definition": {
              "title": "Order UpdateCount",
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
                      "query": "sum:vulcan.processed_update.timing.count{$Environment,$Service,$cluster_name,messagetype:orderupdate}.as_count()"
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
              "y": 21,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5815845323322498,
            "definition": {
              "title": "Update Order Cache Timing",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.avg{$Environment,$Service,$cluster_name,classname:orderupdatehandler,fnname:update_order_cache_update}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.95percentile{$Environment,$Service,$cluster_name,classname:orderupdatehandler,fnname:update_order_cache_update}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.max{$Environment,$Service,$cluster_name,classname:orderupdatehandler,fnname:update_order_cache_update}"
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
              "x": 8,
              "y": 21,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 6980289889102320,
            "definition": {
              "title": "Update Orderbook Levels Cache Timing",
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
                    },
                    {
                      "formula": "query1"
                    },
                    {
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.avg{$Environment,$Service,$cluster_name,classname:orderupdatehandler,fnname:update_price_level}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.95percentile{$Environment,$Service,$cluster_name,classname:orderupdatehandler,fnname:update_price_level}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.generic_function.timing.max{$Environment,$Service,$cluster_name,classname:orderupdatehandler,fnname:update_price_level}"
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
              "y": 23,
              "width": 4,
              "height": 2
            }
          }
        ]
      }
    },
    {
      "id": 3519142303443504,
      "definition": {
        "title": "Invalid Messages",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 6787615124723576,
            "definition": {
              "title": "Order Updates for Non-existent Orders",
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
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.order_update_order_does_not_exist{$Environment}.as_count()"
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
                "include_zero": false,
                "scale": "log"
              }
            },
            "layout": {
              "x": 0,
              "y": 26,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 284124667782840,
            "definition": {
              "title": "Order Updates Previous Total Filled Exceeds Size",
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
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.order_update_old_total_filled_exceeds_size{$Environment}.as_count()"
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
                "include_zero": false,
                "scale": "log"
              }
            },
            "layout": {
              "x": 4,
              "y": 26,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3323582301264028,
            "definition": {
              "title": "Order Updates Updated Total Filled Exceeds Size",
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
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.order_update_total_filled_exceeds_size{$Environment}.as_count()"
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
                "include_zero": false,
                "scale": "log"
              }
            },
            "layout": {
              "x": 8,
              "y": 26,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 2579194859254922,
            "definition": {
              "title": "Order Updates Replaced Order Total Filled Exceeds Size",
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
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:vulcan.order_place_total_filled_exceeds_size{$Environment}.as_count()"
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
                "include_zero": false,
                "scale": "log"
              }
            },
            "layout": {
              "x": 0,
              "y": 28,
              "width": 4,
              "height": 2
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 32,
        "width": 12,
        "height": 31
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
