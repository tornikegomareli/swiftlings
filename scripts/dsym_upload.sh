#!/bin/bash

BUILD_DIR=${BUILD_DIR%/Build/*}
FIREBASE_SCRIPT_PATH="$BUILD_DIR/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"

if [ ! -d "$BUILD_DIR/SourcePackages" ]; then
    echo "SourcePackages directory not found. Skipping dSYM upload."
    exit 0
fi

if [ -f "$FIREBASE_SCRIPT_PATH" ]; then
    echo "Firebase Crashlytics script found at: $FIREBASE_SCRIPT_PATH"
    "$FIREBASE_SCRIPT_PATH" -gsp "${PROJECT_DIR}/CocaColaLoyaltyiOS/GoogleService-Info.plist" -p ios "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"
else
    echo "Firebase Crashlytics script not found at $FIREBASE_SCRIPT_PATH. Skipping dSYM upload."
fi
