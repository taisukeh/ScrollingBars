#!/usr/bin/env bash

set -o pipefail

xcodebuild test -workspace ScrollingBarsTest.xcworkspace \
      -scheme ScrollingBarsTest -sdk iphonesimulator \
      BUILD_ACTIVE_ARCH=NO | xcpretty -t -c
