#!/bin/bash

echo "Killing old instance (if any)"
docker kill vhs-nginx-test
echo "Removing old instance (if any)"
docker rm vhs-nginx-test
