#!/bin/bash

bash entrypoint-curl-url.sh test \
    "https://github.com/ableco/test-files/blob/master/images/test-image-png_4032x3024.png?raw=true" \
    "target/out.$(date '+%Y-%m-%d_%H-%M-%S').csv"
