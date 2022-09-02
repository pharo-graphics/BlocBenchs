#!/bin/bash
set -x
#set -e

# Define SCRIPTS_DIR and REPO_DIR in a way this script can
# be executed:
#   * from any directory
#   * from linux, macos, and windows (with mingw64)
case "$(uname -s)" in
   MINGW*)
     SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -W )"
     ;;
   *)
     SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
     ;;
esac
REPO_DIR="$(dirname "$SCRIPTS_DIR")"


# Get a fresh image
curl https://get.pharo.org/64/110+vm | bash

# Load code overriding image packages
./pharo Pharo.image eval --save $(cat <<EOF
[ EpMonitor disableDuring: [ 
  Author useAuthor: 'Load' during: [
    [	Metacello new
        baseline: 'BlocBenchs';
        repository: 'tonel://$REPO_DIR/src';
        onConflictUseIncoming;
        ignoreImage;
        load.
    ]	on: MCMergeOrLoadWarning
      do: [ :warning | warning load ] ] ]
] timeToRun
EOF
)

# Add this repository to Iceberg
./pharo Pharo.image eval --save $(cat <<EOF
(IceRepositoryCreator new
  location: '$REPO_DIR' asFileReference;
  createRepository) register
EOF
)
