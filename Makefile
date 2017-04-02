test_dependencies:
	pod install

lint_dependencies:
	curl --location https://github.com/realm/SwiftLint/releases/download/0.17.0/SwiftLint.pkg --output SwiftLint.pkg
	sudo installer -pkg SwiftLint.pkg -target /

test:
	xcodebuild -workspace Brisk.xcworkspace -scheme Brisk test

lint:
	swiftlint lint --strict 2> /dev/null

ci:
ifndef ACTION
	$(error ACTION is not defined)
endif
	make $(ACTION)_dependencies
	make $(ACTION)
