#!/bin/bash

if [ -z "$AWS_ACCESS_KEY_ID" ]
then
    echo "You need to set your AWS_ACCESS_KEY_ID"
    exit
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]
then
    echo "You need to set your AWS_SECRET_ACCESS_KEY"
    exit
fi

sed "s/#ACCESS_KEY#/$AWS_ACCESS_KEY_ID/" tempo-helm-values.yaml | sed -e "s/#SECRET_KEY#/$AWS_SECRET_ACCESS_KEY/" | helm template tempo-cluster -f - --namespace tempo-distributed-s3 grafana/tempo-distributed --version 0.21.6  > tempo-distributed-s3.yaml