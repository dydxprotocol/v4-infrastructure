# Market Metadata Service

This directory defines Terraform configs for the Market Metadata Service, a collection of Lambdas that poll, store, and serve metadata about different assets. 

## Source Code Handling

Lambda source code is included in this directory. When applied, `requirements.txt` is installed, and the source files + dependencies are zipped and uploaded. For now this is preferable to a container-based deployment, as it's easier to prototype and may offer improved cold start times (as the Lambdas need to serve live requests). 