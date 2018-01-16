SHELL = /bin/bash
CONFIGURATION ?= Debug
XCODEBUILD = xcodebuild \
			 -workspace Brisk.xcworkspace \
			 -scheme Brisk \
			 -configuration $(CONFIGURATION) \
			 DSTROOT=/

.DEFAULT_GOAL := build

# Developer commands

.PHONY: dependencies
dependencies: ensure_pods

.PHONY: build
build: dependencies
	$(XCODEBUILD) build

.PHONY: install
install: CONFIGURATION = Release
install: dependencies
	$(XCODEBUILD) clean install

.PHONY: test
test: ensure_pods
	$(XCODEBUILD) test

.PHONY: lint
lint: ensure_swiftlint
	./swiftlint/swiftlint lint --strict 2> /dev/null

# Internal commands

.PHONY: ensure_pods
ensure_pods:
	diff Podfile.lock Pods/Manifest.lock > /dev/null || $(MAKE) install_pods

.PHONY: install_pods
install_pods:
	bundle check || bundle install
	bundle exec pod install || bundle exec pod install --repo-update

.PHONY: ensure_swiftlint
ensure_swiftlint:
	diff <(./swiftlint/swiftlint version) <(cat .swiftlint-version) > /dev/null || $(MAKE) install_swiftlint

.PHONY: install_swiftlint
install_swiftlint:
	rm -rf swiftlint
	mkdir swiftlint
	curl --location --fail \
		https://github.com/realm/SwiftLint/releases/download/"$(shell cat .swiftlint-version)"/portable_swiftlint.zip \
		--output swiftlint/swiftlint.zip
	unzip -d swiftlint swiftlint/swiftlint.zip > /dev/null

.PHONY: ci
ci:
ifndef ACTION
	$(error ACTION is not defined)
endif
	make $(ACTION)
