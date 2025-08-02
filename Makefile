.PHONY: all build build-debug build-release test format clean install help

# Default target
all: build

# Build targets
build: build-debug

build-debug:
	@./build-debug.sh

build-release:
	@./build-release.sh

# Test target
test:
	@./run-swift-test.sh

# Format target
format:
	@./format.sh

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	@swift package clean
	@rm -rf .build
	@echo "✅ Clean complete!"

# Install release build
install: build-release
	@echo "📦 Installing swiftlings..."
	@cp .build/release/swiftlings /usr/local/bin/
	@echo "✅ Installation complete! Run 'swiftlings' from anywhere."

# Help
help:
	@echo "Swiftlings Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make build         - Build debug version (default)"
	@echo "  make build-debug   - Build debug version"
	@echo "  make build-release - Build release version"
	@echo "  make test          - Run tests"
	@echo "  make format        - Format code with SwiftFormat and SwiftLint"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make install       - Build and install release version"
	@echo "  make help          - Show this help message"