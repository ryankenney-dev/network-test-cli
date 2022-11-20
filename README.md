network-test-cli
================

Overview
----------------

This is just a script that runs curl in a loop, dumping network status into a CSV file.


Running in Bash
----------------

Run the script:

    bash run-bash.sh

The resulting CSV ends up in:

    target/


Using Docker
----------------

Build and run the container with one command:

    bash build-run-docker.sh

The resulting CSV ends up in:

    target/


Viewing CSV with csvplot.com
----------------

Open the resulting CSV with [csvplot.com](https://www.csvplot.com/)

Drag the `timestamp` field onto the bottom bar

Drag any of the other fields on to the left bar


