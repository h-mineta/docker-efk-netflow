#!/bin/bash

cd ~/docker-efk/elasticsearch/config/template

# set template
curl -XPUT localhost:9200/_template/netflow --data @netflow.json

# check template
curl -XGET localhost:9200/_template/netflow?pretty

# delete index
curl -X DELETE localhost:9200/netflow-*
