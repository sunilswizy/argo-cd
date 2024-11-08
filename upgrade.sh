#!/bin/bash

set -e

new_ver=$1

echo "Upgrading to version $new_ver"

docker tag nginx sunil1912/nginx:$new_ver

docker push sunil1912/nginx:$new_ver

tmp_dir=$(mktemp -d)
echo "Created temp dir $tmp_dir"

git clone https://github.com/sunilswizy/argo-cd.git $tmp_dir

# Use sed instead of set for in-place replacement
sed -i "s|sunil1912/nginx:.*$|sunil1912/nginx:$new_ver|g" $tmp_dir/app/deployment.yaml

cd $tmp_dir
git add app/deployment.yaml
git commit -m "Upgrade to $new_ver"
git push

rm -rf $tmp_dir
