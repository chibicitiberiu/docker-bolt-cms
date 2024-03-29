#!/bin/bash
# This scripts generate tag for specified version
# Syntax: generate_tags.sh <version> <url>

git checkout versions
sed -i "s#ARG BOLT_URL=.*#ARG BOLT_URL=$2#" Dockerfile
git add Dockerfile
git commit -m "Version $1"
git tag -d "$1"
git tag "$1"