SOURCES = menuol tests

.PHONY: lint lint-json format test unused longs

lint:
	@swiftlint --reporter html > swiftlint.html; open swiftlint.html

lint-json:
	@swiftlint --reporter json > swiftlint.json

format:
	swiftformat $(SOURCES)

test:
	xcodebuild test -scheme menuol -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -enableThreadSanitizer YES

unused:
	periphery scan

longs:
	@find menuol \( -name '*.swift' \) -type f -print0 \
		| xargs -0 wc -l \
		| sort -rn \
		| head -n 20
