#!/bin/bash

set -x
set -e

ROOT_DIR=$(pwd)
: "${PHARO_VERSION:=130}"
: "${VERSION_TO_LOAD:=dev}"
: "${DATE:=$(date +%Y-%m-%d)}"

mkdir -p benchmarks/$PHARO_VERSION/$DATE/image

pushd benchmarks/$PHARO_VERSION/$DATE
pushd image

wget -O - get.pharo.org/64/$PHARO_VERSION+vm | bash

./pharo Pharo.image eval --save \
    "Metacello new \
        baseline: 'BlocBenchs'; \
        repository: 'tonel://$ROOT_DIR/src'; \
        load"

# We load the requested version of the packages
./pharo Pharo.image eval --save \
"{ \
    'alexandrie'. \
    'bloc'. \
    'album'. \
    'toplo'. \
    'spec-toplo'. \
} do: [ :repoName | \
    (IceRepository registry \
        select: [ :each | each name asLowercase = repoName ]) \
        do:[ :each | \
        (each branchNamed: '$VERSION_TO_LOAD') checkout. \
            each fetch; pull ] ] \
    displayingProgress: [ :each | each ]. \
"

./pharo-ui Pharo.image eval "BlBCase runAllWithResultsIn: FileLocator imageDirectory / '..' / 'results'. Smalltalk snapshot:false andQuit: true."

popd
rm -rf image
popd