#!/usr/bin/env bash

set -o pipefail
set -x

BASEDIR=$(dirname $0)
cd "$BASEDIR"/../ScrollingBarsTest

xcodebuild test -workspace ScrollingBarsTest.xcworkspace \
      -scheme ScrollingBarsTest -sdk iphonesimulator \
      BUILD_ACTIVE_ARCH=NO | xcpretty -s -c
