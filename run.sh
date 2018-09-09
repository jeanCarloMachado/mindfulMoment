#!/bin/bash

x=$( xcodebuild -showBuildSettings -project mindfulMoment.xcodeproj | grep ' BUILD_DIR =' | sed -e 's/.*= *//' )

DYLD_FRAMEWORK_PATH=$x/Debug DYLD_LIBRARY_PATH=$x/Debug $x/Debug/mindfulMoment.app/Contents/MacOS/mindfulMoment
