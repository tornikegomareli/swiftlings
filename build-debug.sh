#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔨 Building Swiftlings (Debug)...${NC}"

swift build -c debug

echo -e "${GREEN}✅ Debug build complete!${NC}"