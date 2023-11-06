resource "datadog_dashboard_json" "ender" {
  dashboard = <<EOF
{
  "title": "V4 Indexer Ender",
  "description": "",
  "widgets": [
    {
      "id": 7674265371488300,
      "definition": {
        "title": "Ender",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 1719973905086946,
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
                      "query": "max:ecs.fargate.cpu.percent{task_name:*ender-task,$cluster_name,container_name:*ender-service-container} by {task_name,container_id}"
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
            "id": 4698906611633678,
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
                      "query": "max:ecs.fargate.mem.rss{task_name:*ender-task,$cluster_name,container_name:*ender-service-container} by {task_name,container_id}"
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
            "id": 1191034270571868,
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
                      "query": "min:aws.ecs.service.running{cluster:$cluster_name.value,v4service:ender}"
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
            "id": 4442168476470202,
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
                      "query": "max:aws.kafka.sum_offset_lag{$msk_cluster_name,topic:to-ender}"
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
            "id": 619206947726950,
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
                      "query": "max:ender.message_time_in_queue.avg{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "max:ender.message_time_in_queue.95percentile{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "max:ender.message_time_in_queue.max{$Environment,$Service,$cluster_name}"
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
              },
              "markers": []
            },
            "layout": {
              "x": 4,
              "y": 3,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4313854730348314,
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
                    },
                    {
                      "alias": "msg parse failures in last min",
                      "style": {
                        "palette_index": 6,
                        "palette": "warm"
                      },
                      "formula": "query3"
                    },
                    {
                      "alias": "event table update failures in last min",
                      "style": {
                        "palette_index": 3,
                        "palette": "purple"
                      },
                      "formula": "query5"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:ender.received_kafka_message{$Environment,$Service}.as_count().rollup(avg, 60)",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:ender.empty_kafka_message{$Environment,$Service}.rollup(avg, 60)",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:ender.parse_kafka_message.failure{$Environment,$Service}.rollup(avg, 60)",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "avg:ender.block_already_parsed.failure{$Environment,$Service}.rollup(avg, 60).as_count()",
                      "data_source": "metrics",
                      "name": "query5"
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
        "title": "Block Processing",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 1392227558964432,
            "definition": {
              "title": "Ender Processed Block Height",
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
                    },
                    {
                      "alias": "v4 tendermint consensus height",
                      "formula": "query4"
                    },
                    {
                      "alias": "v4 cometbft consensus height",
                      "formula": "query2"
                    }
                  ],
                  "queries": [
                    {
                      "query": "max:ender.processing_block_height{$Environment,$Service}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "max:dydxprotocol.cometbft_consensus_height{$Environment}",
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
              ],
              "yaxis": {
                "include_zero": false
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
            "id": 8677442900434532,
            "definition": {
              "title": "Ender Block Processing Latency Success",
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
                      "alias": "Avg(ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Max (ms)",
                      "style": {
                        "palette_index": 6,
                        "palette": "warm"
                      },
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:ender.processed_block.timing.avg{$Environment,$Service,success:true}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:ender.processed_block.timing.95percentile{$Environment,$Service,success:true}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:ender.processed_block.timing.max{$Environment,$Service,success:true}",
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
              "y": 6,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1162493075260492,
            "definition": {
              "title": "Ender Block Processing Failed",
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
                      "alias": "Avg(ms)",
                      "formula": "query1"
                    },
                    {
                      "alias": "95% (ms)",
                      "formula": "query2"
                    },
                    {
                      "alias": "Max (ms)",
                      "style": {
                        "palette_index": 6,
                        "palette": "warm"
                      },
                      "formula": "query3"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:ender.processed_block.timing.avg{$Environment,$Service,success:false}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "avg:ender.processed_block.timing.95percentile{$Environment,$Service,success:false}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "avg:ender.processed_block.timing.max{$Environment,$Service,success:false}",
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
                      "alias": "count",
                      "formula": "query0"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query0",
                      "query": "avg:ender.processed_block.timing.count{$Environment,$Service,success:false}.as_count()"
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
              "y": 6,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 6315905888407408,
            "definition": {
              "title": "Batch Processing Time",
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
                      "query": "avg:ender.batch_process_time.avg{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.batch_process_time.95percentile{$Environment,$Service,$cluster_name}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:ender.batch_process_time.max{$Environment,$Service,$cluster_name}"
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
              "y": 8,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8498110465635644,
            "definition": {
              "title": "Batch Size",
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
                      "query": "avg:ender.batch_size.median{$Environment,$Service}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.batch_size.95percentile{$Environment,$Service}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:ender.batch_size.max{$Environment,$Service}"
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
              "y": 8,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 659088676025712,
            "definition": {
              "title": "Batches in a Block",
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
                      "query": "avg:ender.num_batches_in_block.avg{$Environment,$Service}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.num_batches_in_block.95percentile{$Environment,$Service}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:ender.num_batches_in_block.max{$Environment,$Service}"
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
              "y": 8,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8938748914537290,
            "definition": {
              "title": "Event Type frequency",
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
                      "alias": "MarketEvent count",
                      "formula": "query1"
                    },
                    {
                      "alias": "OrderFillEvent count",
                      "formula": "query2"
                    },
                    {
                      "alias": "SubaccountUpdateEvent count",
                      "formula": "query3"
                    },
                    {
                      "alias": "TransferEvent count",
                      "formula": "query4"
                    },
                    {
                      "alias": "FundingEvent count",
                      "formula": "query5"
                    },
                    {
                      "alias": "StatefulOrderEvent count",
                      "formula": "query6"
                    },
                    {
                      "alias": "PerpetualMarketCreateEvent count",
                      "formula": "query7"
                    },
                    {
                      "alias": "LiquidityTierUpsertEvent count",
                      "formula": "query8"
                    },
                    {
                      "alias": "AssetCreateEvent count",
                      "formula": "query9"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:marketevent}.as_count().rollup(avg, 60)"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:orderfillevent}.as_count().rollup(avg, 60)"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:subaccountupdateevent}.as_count().rollup(avg, 60)"
                    },
                    {
                      "name": "query4",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:transferevent}.as_count().rollup(avg, 60)"
                    },
                    {
                      "name": "query5",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:fundingevent}.as_count().rollup(avg, 60)"
                    },
                    {
                      "name": "query6",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:statefulorderevent}.as_count().rollup(avg, 60)"
                    },
                    {
                      "name": "query7",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:perpetualmarketcreateevent}.as_count().rollup(avg, 60)"
                    },
                    {
                      "name": "query8",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:liquiditytierupsertevent}.as_count().rollup(avg, 60)"
                    },
                    {
                      "name": "query9",
                      "data_source": "metrics",
                      "query": "sum:ender.handle_event.timing.count{$Environment,$Service,eventtype:assetcreateevent}.as_count().rollup(avg, 60)"
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
          }
        ]
      }
    },
    {
      "id": 3519142303443504,
      "definition": {
        "title": "Handlers",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 7228183408491306,
            "definition": {
              "title": "Order Fill Handler Metrics (avg)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:orderfillevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,eventtype:orderfillevent}"
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
              "y": 13,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 44474999340134,
            "definition": {
              "title": "Order Fill Handler Metrics (95%)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{$Environment,$Service,eventtype:orderfillevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,eventtype:orderfillevent}"
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
              "y": 13,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5369691550666448,
            "definition": {
              "title": "Order Fill Handler Metrics (max)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:orderfillevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,eventtype:orderfillevent}"
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
              "y": 13,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 5975978528365952,
            "definition": {
              "title": "Subaccount Update Handler Metrics (avg)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:subaccountupdateevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,eventtype:subaccountupdateevent}"
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
              "y": 15,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 2371605848090710,
            "definition": {
              "title": "Subaccount Update Handler Metrics (95%)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{eventtype:subaccountupdateevent,$Environment,$Service} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{eventtype:subaccountupdateevent,$Environment,$Service}"
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
              "y": 15,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1306814740535988,
            "definition": {
              "title": "Subaccount Update Handler Metrics (max)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:subaccountupdateevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,eventtype:subaccountupdateevent}"
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
              "y": 15,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 6162410151079282,
            "definition": {
              "title": "Market Handler Metrics (avg)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:marketevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,eventtype:marketevent}"
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
              "y": 17,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 781023063240698,
            "definition": {
              "title": "Market Handler Metrics (95%)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{$Environment,$Service,eventtype:marketevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,eventtype:marketevent}"
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
              "y": 17,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3795138445174226,
            "definition": {
              "title": "Market Handler Metrics (max)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:marketevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,eventtype:marketevent}"
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
              "y": 17,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 6506728734781804,
            "definition": {
              "title": "Transfer Handler Metrics (avg)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:transferevent*} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,class:transferhandler}"
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
              "y": 19,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 2166478134211908,
            "definition": {
              "title": "Transfer Handler Metrics (95%)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{$Environment,$Service,eventtype:transferevent*} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,eventtype:transferevent*}"
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
              "y": 19,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1904598562942338,
            "definition": {
              "title": "Transfer Handler Metrics (max)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:transferevent*} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,eventtype:transferevent*}"
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
              "y": 19,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 4293391004494110,
            "definition": {
              "title": "Funding Handler Metrics (avg)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:fundingevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,eventtype:fundingevent}"
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
              "y": 21,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3485173661741046,
            "definition": {
              "title": "Funding Handler Metrics (95%)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{$Environment,$Service,eventtype:fundingevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,eventtype:fundingevent}"
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
              "y": 21,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 63146674063398,
            "definition": {
              "title": "Funding Handler Metrics (max)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:fundingevent} by {fnname}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,eventtype:fundingevent}"
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
              "y": 21,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 1036075888844532,
            "definition": {
              "title": "Stateful Order Handler Metrics (avg)",
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
                    },
                    {
                      "formula": "query4"
                    },
                    {
                      "formula": "query5"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:statefulorderevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,classname:statefulorderplacementhandler}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,classname:statefulorderexpirationhandler}"
                    },
                    {
                      "name": "query4",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,classname:statefulordercancelationhandler}"
                    },
                    {
                      "name": "query5",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,classname:statefulorderremovalhandler}"
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
              "y": 23,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 447316509760946,
            "definition": {
              "title": "Stateful Order Handler Metrics (95%)",
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
                    },
                    {
                      "formula": "query4"
                    },
                    {
                      "formula": "query5"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{$Environment,$Service,eventtype:statefulorderevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,classname:statefulorderplacementhandler}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,classname:statefulorderexpirationhandler}"
                    },
                    {
                      "name": "query4",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,classname:statefulordercancelationhandler}"
                    },
                    {
                      "name": "query5",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,classname:statefulorderremovalhandler}"
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
              "y": 23,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 15913965816198,
            "definition": {
              "title": "Stateful Order Handler Metrics (max)",
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
                    },
                    {
                      "formula": "query4"
                    },
                    {
                      "formula": "query5"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:statefulorderevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,classname:statefulorderplacementhandler}"
                    },
                    {
                      "name": "query3",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,classname:statefulorderexpirationhandler}"
                    },
                    {
                      "name": "query4",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,classname:statefulordercancelationhandler}"
                    },
                    {
                      "name": "query5",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,classname:statefulorderremovalhandler}"
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
              "y": 23,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 8232777336586544,
            "definition": {
              "title": "Asset Handler Metrics (avg)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:assetcreateevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,classname:assetcreationhandler}"
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
              "y": 25,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 7023721873558032,
            "definition": {
              "title": "Asset Creation Handler Metrics (95%)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{$Environment,$Service,eventtype:assetcreateevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,classname:assetcreationhandler}"
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
              "y": 25,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 2521661296883830,
            "definition": {
              "title": "Asset Creation Handler Metrics (max)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:assetcreateevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,classname:assetcreationhandler}"
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
              "y": 25,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 7254478644607454,
            "definition": {
              "title": "Perpetual Market Handler Metrics (avg)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:perpetualmarketcreateevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,classname:perpetualmarketcreationhandler}"
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
              "y": 27,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3449410088269996,
            "definition": {
              "title": "Perpetual Market Handler Metrics (95%)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{$Environment,$Service,eventtype:perpetualmarketcreateevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,classname:perpetualmarketcreationhandler}"
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
              "y": 27,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 3651649040009954,
            "definition": {
              "title": "Perpetual Market Handler Metrics (max)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:perpetualmarketcreateevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,classname:perpetualmarketcreationhandler}"
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
              "y": 27,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 2050175477011680,
            "definition": {
              "title": "Liquidity Tier Handler Metrics (avg)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.avg{$Environment,$Service,eventtype:liquiditytierupsertevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.avg{$Environment,$Service,classname:liquiditytierhandler}"
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
              "y": 29,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 7079814083503344,
            "definition": {
              "title": "Liquidity Tier Handler Metrics (95%)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.95percentile{$Environment,$Service,eventtype:liquiditytierupsertevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.95percentile{$Environment,$Service,classname:liquiditytierhandler}"
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
              "y": 29,
              "width": 4,
              "height": 2
            }
          },
          {
            "id": 136548017662728,
            "definition": {
              "title": "Liquidity Tier Handler Metrics (max)",
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
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:ender.generic_function.timing.max{$Environment,$Service,eventtype:liquiditytierupsertevent}"
                    },
                    {
                      "name": "query2",
                      "data_source": "metrics",
                      "query": "avg:ender.handle_event.timing.max{$Environment,$Service,classname:liquiditytierhandler}"
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
              "y": 29,
              "width": 4,
              "height": 2
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 12,
        "height": 32
      }
    }
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
