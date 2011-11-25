TESTS = test/*.coffee

test-all:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--require coffee-script \
		$(TESTS)
