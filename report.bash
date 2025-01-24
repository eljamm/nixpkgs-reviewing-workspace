#!/usr/bin/env bash

set -euxo pipefail

pr_number="$1"
run_id="$2"
output_dir="$3"

download_cmd=""
report="$output_dir/report.md"

runners="X64-Linux ARM64-Linux X64-macOS ARM64-macOS"

for runner in $runners; do
    download_cmd="$download_cmd -n nixpkgs-review-report-pr-${pr_number}-${runner}"
done

gh run download "$run_id" $download_cmd --dir "$output_dir"
echo "Downloaded the files in $output_dir"

tree "$output_dir"

echo >"$report" # clear old report, if it exists

for runner in $runners; do
    runner_report=$(cat "$output_dir/nixpkgs-review-report-pr-${pr_number}-${runner}/report.md")

    # The `nixpkgs-review` header is included with the first runner (X64-Linux)
    # so we don't need to include the ones from subsequent runners.
    if [ "$runner" != "X64-Linux" ]; then
        runner_report=$(echo "$runner_report" | sed '1,5d')
    fi

    echo "$runner_report" >>"$report"
done

cat "$report"
