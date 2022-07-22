 #!/bin/bash

set -eou pipefail

SCHEME="Orbit-Package"
SNAPSHOTS_DIR="Snapshots"

CONFIGURATIONS=(
    "iPhone SE (1st generation)" "15.5"
    "iPhone 13" "15.5"
    "iPad (9th generation)" "15.5"
)

echo "Verifying all runtimes are available..."

for (( i=1; i<${#CONFIGURATIONS[@]}; i+=2 )); do
    IOS_VERSION=${CONFIGURATIONS[i]}
    echo "Checking for iOS $IOS_VERSION"
    xcrun simctl list runtimes | grep -q "iOS $IOS_VERSION"
done

for (( i=0; i<${#CONFIGURATIONS[@]}; i+=2 )); do
    SIMULATOR_NAME=${CONFIGURATIONS[i]}
    IOS_VERSION=${CONFIGURATIONS[i+1]}
    
    echo "Setting up simulator of $SIMULATOR_NAME ($IOS_VERSION) ..."
    
    SIMCTL_RUNTIME_VERSION=$(echo "$IOS_VERSION" | tr "." "-")
    RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-$SIMCTL_RUNTIME_VERSION"
    SIMULATOR_ID=$(xcrun simctl create "$SIMULATOR_NAME" "$SIMULATOR_NAME" "$RUNTIME")
    
    echo "Generating snapshots for $SIMULATOR_NAME ($IOS_VERSION) ..."
    
    xcodebuild test -quiet -scheme $SCHEME -destination "platform=iOS Simulator,id=$SIMULATOR_ID,OS=$IOS_VERSION" OTHER_SWIFT_FLAGS="-D XCODE_IS_SNAPSHOTS_RECORDING" | grep -vE 'sec,|started|Test session results|.xcresult'
    
    git -C $SNAPSHOTS_DIR/ add .
done
