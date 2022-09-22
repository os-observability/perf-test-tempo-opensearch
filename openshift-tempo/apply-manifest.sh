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

sed  -e 's|#ACCESS_KEY#|'$AWS_ACCESS_KEY_ID'|' -e 's|#SECRET_KEY#|'$AWS_SECRET_ACCESS_KEY'|' tempo-helm-values.yaml | helm template tempo-cluster -f - --namespace tempo-distributed-s3 grafana/tempo-distributed --version 0.21.6 | oc apply -n tempo-distributed-s3 -f - 
