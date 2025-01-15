#!/bin/bash

set -x
set -e

SCRIPT_DIR=$(realpath "$(dirname ${BASH_SOURCE[0]})")

PHARO_VERSION=130 VERSION_TO_LOAD=dev ${SCRIPT_DIR}/runBenchmarksInPharo.sh
PHARO_VERSION=120 VERSION_TO_LOAD=dev ${SCRIPT_DIR}/runBenchmarksInPharo.sh
PHARO_VERSION=110 VERSION_TO_LOAD=dev ${SCRIPT_DIR}/runBenchmarksInPharo.sh