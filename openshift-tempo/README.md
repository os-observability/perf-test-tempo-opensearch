# Grafana Tempo openshift deployment

This directory contains all the necesary files to deploy grafana tempo on OpenShift, along with a trace generator and dashboard that allow us to monitor the deployment


Before executing any command you need to create the namespace `tempo-distributed-s3`.

## Deploying tempo
For deploying tempo you can execute the following command:

```
make deploy-tempo
```

You need to make sure to set your env variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, those variables are needed
to configure tempo access to the S3 bucket.

## Deploying tracegen

For deploying the trace generator you can execute the following command:

```
make deploy-trace-generator
```

In order to increase the spans/second generation you need to move the trace generator config and redeploy it. You can modify the load-generator.yaml file, around line 379.

## Deploying grafana dashboards

```
make deploy-grafana
```