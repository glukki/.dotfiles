# Makefile for running tests

.PHONY: test test-all clean

test:
	@echo "Running all tests..."
	@for test_script in tests/test_*.sh; do \
		echo "Executing $$test_script..."; \
		bash "$$test_script" || exit 1; \
	done
	@echo "All tests passed!"

test-all: test

clean:
	@echo "Cleaning up test artifacts..."
	@rm -rf tests/test_*.pdf
	@echo "Done."
