#!/bin/bash

set -e

# Configuration
DEPS_DIR=".deps"
SWIFTFORMAT_VERSION="0.53.0"
SWIFTLINT_VERSION="0.54.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create deps directory if it doesn't exist
mkdir -p "$DEPS_DIR"

# Function to download and extract SwiftFormat
install_swiftformat() {
    local install_dir="$DEPS_DIR/swiftformat"
    
    if [ -f "$install_dir/swiftformat" ]; then
        echo -e "${GREEN}SwiftFormat already installed${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Installing SwiftFormat v${SWIFTFORMAT_VERSION}...${NC}"
    
    mkdir -p "$install_dir"
    
    # Download SwiftFormat
    local url="https://github.com/nicklockwood/SwiftFormat/releases/download/${SWIFTFORMAT_VERSION}/swiftformat.zip"
    local temp_zip="$DEPS_DIR/swiftformat.zip"
    
    curl -L -o "$temp_zip" "$url"
    unzip -q -o "$temp_zip" -d "$install_dir"
    rm "$temp_zip"
    
    # Make executable
    chmod +x "$install_dir/swiftformat"
    
    echo -e "${GREEN}✅ SwiftFormat installed successfully${NC}"
}

# Function to download and extract SwiftLint
install_swiftlint() {
    local install_dir="$DEPS_DIR/swiftlint"
    
    if [ -f "$install_dir/swiftlint" ]; then
        echo -e "${GREEN}SwiftLint already installed${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Installing SwiftLint v${SWIFTLINT_VERSION}...${NC}"
    
    mkdir -p "$install_dir"
    
    # Download SwiftLint
    local url="https://github.com/realm/SwiftLint/releases/download/${SWIFTLINT_VERSION}/portable_swiftlint.zip"
    local temp_zip="$DEPS_DIR/swiftlint.zip"
    
    curl -L -o "$temp_zip" "$url"
    unzip -q -o "$temp_zip" -d "$install_dir"
    rm "$temp_zip"
    
    # Make executable
    chmod +x "$install_dir/swiftlint"
    
    echo -e "${GREEN}✅ SwiftLint installed successfully${NC}"
}

# Parse command line arguments
case "$1" in
    --swiftformat)
        install_swiftformat
        ;;
    --swiftlint)
        install_swiftlint
        ;;
    --all)
        install_swiftformat
        install_swiftlint
        ;;
    *)
        echo "Usage: $0 [--swiftformat|--swiftlint|--all]"
        echo "  --swiftformat  Install SwiftFormat"
        echo "  --swiftlint    Install SwiftLint"
        echo "  --all          Install both tools"
        exit 1
        ;;
esac