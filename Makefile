TESTS = test/*.coffee

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--require coffee-script \
    --reporter list \
		$(TESTS)

test-ci:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--require coffee-script \
    --reporter tap \
    --timeout 4000 \
		$(TESTS) >> result.tap


.PHONY: test test-ci
