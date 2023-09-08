# Metric Ingestor

The Metric Ingestor module uses the Datadog Agent container running on ECS in daemon mode to
consume metrics from external hosts running prometheus endpoints. The Metric Ingestor does not
consume metrics for private/internal hosts such as validators or full nodes running on our
own infrastructure. (Those hosts have their own Datadog sidecars. See the `validator` module for
more information.)

Metric Ingestor runs in Daemon mode to take advantage of public EIP. This is useful if an external
party wishes to whitelist our IP.

Validators to scrape are configured via the `validators` variable, like this:

```hcl
validators = [
{
  name = "Figment",
  openmetrics_endpoint = "https://validator.figment.com:1317"
},
{
  name = "Frens",
  // HTTP basic auth example
  openmetrics_endpoint = "https://username:password@validator.frens.com:1317"
}]
```
