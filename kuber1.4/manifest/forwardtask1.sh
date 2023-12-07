#!/usr/bin/env sh
kubectl port-forward deployment/deploytask1 9001:80 & \
kubectl port-forward deployment/deploytask1 9002:8080 &
