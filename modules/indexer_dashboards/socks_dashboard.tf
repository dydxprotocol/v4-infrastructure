resource "datadog_dashboard_json" "socks" {
  dashboard = <<EOF
{
  "title": "V4 Indexer Socks",
  "description": "",
  "widgets": [
    {
      "id": 4647534798635852,
      "definition": {
        "title": "Socks",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 7318245889214448,
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
                      "query": "max:ecs.fargate.cpu.percent{task_name:*socks-task,$cluster_name,container_name:*socks-service-container} by {task_name,container_id}"
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
            "id": 7082174723337478,
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
                      "query": "max:ecs.fargate.mem.rss{task_name:*socks-task,$cluster_name,container_name:*socks-service-container} by {task_name,container_id}"
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
            "id": 2254057628579770,
            "definition": {
              "title": "Message Forwarding Latency",
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
                      "alias": "Avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "95% (ms)",
                      "formula": "query2"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:socks.forward_message.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:socks.forward_message.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
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
              "y": 0,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5136594378205182,
            "definition": {
              "type": "free_text",
              "text": "Kafka",
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
            "id": 1427040631058316,
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
                      "formula": "top(query1, 5, 'mean', 'asc')"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:aws.kafka.max_offset_lag{consumer_group:socks_*,$msk_cluster_name} by {consumer_group}"
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
            "id": 810503967841644,
            "definition": {
              "title": "Message Time in Queue",
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
                      "alias": "max (ms)",
                      "formula": "query3"
                    },
                    {
                      "alias": "Avg (ms)",
                      "formula": "query4"
                    },
                    {
                      "alias": "95% (ms)",
                      "formula": "query5"
                    },
                    {
                      "alias": "max (ms)",
                      "formula": "query6"
                    }
                  ],
                  "queries": [
                    {
                      "query": "max:socks.message_time_in_queue.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "max:socks.message_time_in_queue.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "max:socks.message_time_in_queue.max{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "max:socks.forward_message.message_time_in_queue.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query4"
                    },
                    {
                      "query": "max:socks.forward_message.message_time_in_queue.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query5"
                    },
                    {
                      "query": "max:socks.forward_message.message_time_in_queue.max{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query6"
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
              "x": 4,
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1879068026839852,
            "definition": {
              "type": "free_text",
              "text": "Message Forwarding",
              "color": "#4d4d4d",
              "font_size": "24",
              "text_align": "left"
            },
            "layout": {
              "x": 0,
              "y": 5,
              "width": 12,
              "height": 1
            }
          },
          {
            "id": 7199039943554564,
            "definition": {
              "title": "Message to Forward QPS",
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
                      "alias": "qps",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:socks.message_to_forward{$Environment,$Service}.as_rate()",
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
              ]
            },
            "layout": {
              "x": 0,
              "y": 6,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8163527023021030,
            "definition": {
              "title": "% of Messages Forwarded",
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
                      "alias": "% of Messages Forwarded",
                      "formula": "query2 / query1 * 100"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:socks.forward_message_with_subscribers{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:socks.message_to_forward{$Environment,$Service}.as_count()",
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
              "x": 4,
              "y": 6,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3134784320636988,
            "definition": {
              "title": "Subscribe Send Message Latency",
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
                      "alias": "avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "95% (ms)",
                      "formula": "query2"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:socks.subscribe_send_message.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:socks.subscribe_send_message.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
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
              "y": 6,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 6887843049406098,
            "definition": {
              "title": "Socks Update Perpetual Market Loop Latency",
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
                      "alias": "avg (ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "95% (ms)",
                      "formula": "query2"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:socks.loops.update_perpetual_markets.avg{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:socks.loops.update_perpetual_markets.95percentile{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
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
              "y": 8,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4448252288059946,
            "definition": {
              "title": "Subscriptions Channel Size",
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
                      "alias": "avg",
                      "formula": "query1"
                    },
                    {
                      "alias": "max",
                      "formula": "query2"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:socks.subscriptions.channel_size{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "max:socks.subscriptions.channel_size{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query2"
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
              "y": 8,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5484955330270804,
            "definition": {
              "title": "Client Forwarding Success Rates",
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
                      "alias": "Individual Success Rate",
                      "formula": "query4 / (query3 + query4)"
                    },
                    {
                      "alias": "Batch Success Rate",
                      "formula": "query1 / (query1 + query2)"
                    }
                  ],
                  "response_format": "timeseries",
                  "queries": [
                    {
                      "query": "avg:socks.forward_to_client_batch_success{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:socks.forward_to_client_batch_error{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:socks.forward_to_client_error{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:socks.forward_to_client_success{$Environment,$Service}.as_count()",
                      "data_source": "metrics",
                      "name": "query4"
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
              "y": 8,
              "width": 4,
              "height": 2
            }
          },
          {
            "id":6421181883162304,
            "definition":{
               "title":"Stream Destroyed Errors",
               "title_size":"16",
               "title_align":"left",
               "show_legend":true,
               "legend_layout":"horizontal",
               "legend_columns":[
                  "avg",
                  "min",
                  "max",
                  "value",
                  "sum"
               ],
               "type":"timeseries",
               "requests":[
                  {
                     "formulas":[
                        {
                           "formula":"query4"
                        }
                     ],
                     "queries":[
                        {
                           "query":"avg:socks.ws_send.stream_destroyed_errors{$Environment,$Service}.as_count()",
                           "data_source":"metrics",
                           "name":"query4"
                        }
                     ],
                     "response_format":"timeseries",
                     "style":{
                        "palette":"dog_classic",
                        "line_type":"solid",
                        "line_width":"normal"
                     },
                     "display_type":"line"
                  }
               ]
            },
            "layout":{
               "x":8,
               "y":10,
               "width":4,
               "height":2
            }
          },
          {
            "id":1855914397159130,
            "definition":{
               "title":"Message Not Sent Because Websocket Not Open",
               "title_size":"16",
               "title_align":"left",
               "show_legend":true,
               "legend_layout":"horizontal",
               "legend_columns":[
                  "avg",
                  "min",
                  "max",
                  "value",
                  "sum"
               ],
               "time":{

               },
               "type":"timeseries",
               "requests":[
                  {
                     "formulas":[
                        {
                           "formula":"query4"
                        }
                     ],
                     "queries":[
                        {
                           "query":"avg:socks.ws_message_not_sent{$Environment,$Service}.as_rate()",
                           "data_source":"metrics",
                           "name":"query4"
                        }
                     ],
                     "response_format":"timeseries",
                     "style":{
                        "palette":"dog_classic",
                        "line_type":"solid",
                        "line_width":"normal"
                     },
                     "display_type":"line"
                  }
               ]
            },
            "layout":{
               "x":8,
               "y":12,
               "width":4,
               "height":2
            }
          },
          {
            "id": 870204027095636,
            "definition": {
              "title": "Initial GET Response Latency (v4_markets)",
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
                      "alias": "95pct",
                      "formula": "query1"
                    },
                    {
                      "alias": "avg",
                      "formula": "query2"
                    },
                    {
                      "alias": "max",
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:socks.initial_response_get.95percentile{$cluster_name,channel:v4_markets}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:socks.initial_response_get.avg{$cluster_name,channel:v4_markets}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:socks.initial_response_get.max{$cluster_name,channel:v4_markets}",
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
              "y": 10,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 6486907288951536,
            "definition": {
              "title": "Number of Concurrent Connections",
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
                      "query": "avg:socks.num_concurrent_connections{$Environment,$Service}",
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
              "x": 4,
              "y": 10,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4038310831400512,
            "definition": {
              "title": "Initial GET Response Latency (v4_orderbook)",
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
                      "alias": "95pct",
                      "formula": "query1"
                    },
                    {
                      "alias": "avg",
                      "formula": "query2"
                    },
                    {
                      "alias": "max",
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:socks.initial_response_get.95percentile{$cluster_name,channel:v4_orderbook}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:socks.initial_response_get.avg{$cluster_name,channel:v4_orderbook}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:socks.initial_response_get.max{$cluster_name,channel:v4_orderbook}",
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
              "x": 8,
              "y": 10,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 6471300902234644,
            "definition": {
              "title": "Initial GET Response Latency (v4_trades)",
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
                      "alias": "95pct",
                      "formula": "query1"
                    },
                    {
                      "alias": "avg",
                      "formula": "query2"
                    },
                    {
                      "alias": "max",
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:socks.initial_response_get.95percentile{$cluster_name,channel:v4_trades}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:socks.initial_response_get.avg{$cluster_name,channel:v4_trades}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:socks.initial_response_get.max{$cluster_name,channel:v4_trades}",
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
              "y": 12,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8728511752582676,
            "definition": {
              "title": "Initial GET Response Latency (v4_subaccounts)",
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
                      "alias": "95pct",
                      "formula": "query1"
                    },
                    {
                      "alias": "avg",
                      "formula": "query2"
                    },
                    {
                      "alias": "max",
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:socks.initial_response_get.95percentile{$cluster_name,channel:v4_subaccounts}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:socks.initial_response_get.avg{$cluster_name,channel:v4_subaccounts}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:socks.initial_response_get.max{$cluster_name,channel:v4_subaccounts}",
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
              "x": 4,
              "y": 12,
              "width": 4,
              "height": 2
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 72,
        "width": 12,
        "height": 15
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
