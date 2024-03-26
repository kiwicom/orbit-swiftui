 #!/bin/bash

set -eou pipefail

SCHEME="Orbit-Package"
IOS_VERSION="17.0"

SIMULATORS=(
    "iPhone SE (3rd generation)"
)

echo "Verifying iOS $IOS_VERSION runtime is available..."
xcrun simctl list runtimes | grep -q "iOS $IOS_VERSION"

for (( i=0; i<${#SIMULATORS[@]}; i+=1 )); do
    SIMULATOR_NAME=${SIMULATORS[i]}

    echo "Setting up simulator $SIMULATOR_NAME ($IOS_VERSION) ..."

    SIMCTL_RUNTIME_VERSION=$(echo "$IOS_VERSION" | tr "." "-")
    RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-$SIMCTL_RUNTIME_VERSION"
    SIMULATOR_ID=$(xcrun simctl create "$SIMULATOR_NAME" "$SIMULATOR_NAME" "$RUNTIME")

    echo "Generating snapshots for $SIMULATOR_NAME ($IOS_VERSION) ..."

    xcodebuild test -quiet -scheme $SCHEME -destination "platform=iOS Simulator,id=$SIMULATOR_ID,OS=$IOS_VERSION" OTHER_SWIFT_FLAGS="-D XCODE_IS_SNAPSHOTS_RECORDING"

    git -C Snapshots/ add .
    git commit -m "Snapshots - $SIMULATOR_NAME" || true
done

echo "Pushing any snapshot commits..."
git push
