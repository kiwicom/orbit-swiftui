 #!/bin/bash

set -eou pipefail

COMPONENTS_DIR="Sources/Orbit/Components"
TESTS_DIR="Tests/SnapshotTests/Components"

echo "Checking that all components have snapshot tests..."

ERROR=false

for COMPONENT_NAME in `find $COMPONENTS_DIR -type f -exec basename {} .swift \; | sort`; do
    TEST_FILEPATH="$TESTS_DIR/${COMPONENT_NAME}Tests.swift"    
    
    if test -f $TEST_FILEPATH; then
        echo "✔ $TEST_FILEPATH"
    else
        echo "✖ $TEST_FILEPATH"
        echo "    file not found!"
        ERROR=true
    fi
done

if [ "$ERROR" = true ]; then
    echo "Some components don't have snapshot tests!"
    exit 1
else
    echo "All components have snapshot tests!"
fi