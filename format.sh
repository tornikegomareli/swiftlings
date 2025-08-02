#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Running code formatters...${NC}"

# Run SwiftFormat
echo -e "\n${YELLOW}Running SwiftFormat...${NC}"
./scripts/install-dep.sh --swiftformat
./.deps/swiftformat/swiftformat .

# Run SwiftLint
echo -e "\n${YELLOW}Running SwiftLint...${NC}"
./scripts/install-dep.sh --swiftlint
./.deps/swiftlint/swiftlint lint --quiet

echo -e "\n${GREEN}✅ Formatting complete!${NC}"