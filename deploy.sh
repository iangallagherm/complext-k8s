#!/bin/bash

docker build -t iangallagher/multi-client:latest -t iangallagher/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t iangallagher/multi-server:latest -t iangallagher/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t iangallagher/multi-worker:latest -t iangallagher/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push iangallagher/multi-client:latest
docker push iangallagher/multi-server:latest
docker push iangallagher/multi-worker:latest
docker push iangallagher/multi-client:$SHA
docker push iangallagher/multi-server:$SHA
docker push iangallagher/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=iangallagher/multi-server:$SHA
kubectl set image deployments/client-deployment client=iangallagher/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=iangallagher/multi-worker:$SHA