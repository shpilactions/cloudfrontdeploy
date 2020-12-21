#!/bin/bash

set -e

tags=()
source=$1
target=$2
cloudfront=$3
export commit=$GITHUB_SHA
export branch=${GITHUB_REF##*/}

echo '[Debug] Authenticate in AWS'
mkdir -p ~/.aws
wget -O ~/.aws/config http://secrets.local.shpil.dev/aws/config
wget -O ~/.aws/credentials http://secrets.local.shpil.dev/aws/credentials

echo '[Debug] Push files to AWS S3'
aws s3 sync $source $target --delete --acl public-read

echo '[Debug] Regenerate '
aws cloudfront create-invalidation --distribution-id $cloudfront --paths '/*'

echo '[Info] Done.'