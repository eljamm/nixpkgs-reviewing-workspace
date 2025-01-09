#!/usr/bin/env bash

set -euxo pipefail

pr_number="$1"
output_dir="$(mktemp --directory)"

sleep 10 # NOTE: to ensure that the correct ID is fetched
# TODO: get ID from PR number?
run_id="$(gh run list --workflow=nixpkgs-review.yml --branch improve-security --limit 1 --json databaseId --jq '.[].databaseId')"

gh run watch "$run_id" # Don't use --exit-status to make sure the downloading
gh run download "$run_id" --dir "$output_dir"

echo "Downloaded the files in $output_dir"

exec ./report.bash "$pr_number" "$output_dir"
