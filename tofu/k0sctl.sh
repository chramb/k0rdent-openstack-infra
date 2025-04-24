#!/bin/sh
tofu output -raw k0sctl | k0sctl apply -c -
