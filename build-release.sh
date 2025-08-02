#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Building Swiftlings (Release)...${NC}"

swift build -c release

echo -e "${GREEN}✅ Release build complete!${NC}"
echo -e "${GREEN}Binary location: .build/release/swiftlings${NC}"