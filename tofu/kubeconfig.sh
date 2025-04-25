#!/bin/sh
tofu output -raw k0sctl | k0sctl kubeconfig -c - > ~/.kube/config

