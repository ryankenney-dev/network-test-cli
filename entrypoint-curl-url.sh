#/bin/bash

set -e

SCRIPT_FILE="$(basename "$0")"
# NOTE: readlink will not work in OSX
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

curl_log_format='%{time_total},%{time_namelookup},%{time_connect},%{time_appconnect},%{time_pretransfer},%{time_redirect},%{time_starttransfer},%{http_code},%{url_effective}'

function print_header() {
    echo "timestamp,${curl_log_format}"
}

function test_url() {
    local url="$1"
    shift

    echo -n "`date '+%Y-%m-%d_%H:%M:%S'`,"
    curl -kLs "$url" -o /dev/null -w "${curl_log_format}\\n"
}

function print_usage_and_exit() {
    echo "" >&2
    echo "${SCRIPT_FILE} test <urls-file>" >&2
    echo "" >&2
    echo "  header <csv-file>" >&2
    echo "      Print the CSV header to the csv file." >&2
    echo "" >&2
    echo "  test <url> <csv-file>" >&2
    echo "      Test the given URL, writing the result to the target csv file." >&2
    echo "" >&2
    exit 1
}

if [[ $# -lt 1 ]]; then
    print_usage_and_exit
fi

if [[ "$1" == "header" ]]; then
    shift
    if [[ $# -lt 1 ]]; then
        print_usage_and_exit
    fi
    out_csv_file="$1"
    shift

    print_header | tee -a "$out_csv_file"

elif [[ "$1" == "test" ]]; then
    shift
    if [[ $# -lt 2 ]]; then
        print_usage_and_exit
    fi
    url="$1"
    shift
    out_csv_file="$1"
    shift

    test_url "$url" 2>&1 | tee -a "$out_csv_file"

else
    print_usage_and_exit
fi
