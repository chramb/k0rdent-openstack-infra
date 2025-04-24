#!/bin/sh
tofu -chdir=../tofu/ output -raw clusterapi-creds | kubectl  apply -f -
