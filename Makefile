CURRENT_SIGN_SETTING := $(shell git config commit.gpgSign)
PACKAGE_DIRECTORY=iterwrite
TEST_DIRECTORY=tests
LINTING_LINELENGTH=120

.PHONY: help clean-pyc clean-build isort-test isort darglint-test black-test black pytest test format tox

help:
	@echo "    help: Print this help"
	@echo "    clean-pyc: Remove python artifacts."
	@echo "    clean-build: Remove build artifacts."
	@echo "    isort-test: Test whether import statements are sorted."
	@echo "    isort: Sort import statements."
	@echo "    darglint-test: Test whether docstrings are valid."
	@echo "    black-test: Test whether black formatting is adhered to."
	@echo "    black: Apply black formatting."
	@echo "    pytest: Run pytest suite."
	@echo "    test: Run all tests."
	@echo "    format: Apply all formatting tools."
	@echo "    tox: Run tox testing."

clean-pyc:
	find . -regex '^./\($(PACKAGE_DIRECTORY)\|$(TEST_DIRECTORY)\)/.*\.py[co]' -delete
	find . -regex '^./\($(PACKAGE_DIRECTORY)\|$(TEST_DIRECTORY)\)/.*__pycache__' -delete

clean-build:
	rm --force --recursive build/
	rm --force --recursive dist/
	rm --force --recursive *.egg-info

isort-test: clean-pyc
	isort --recursive --check-only --line-width $(LINTING_LINELENGTH) $(PACKAGE_DIRECTORY) $(TEST_DIRECTORY)

isort: clean-pyc
	isort --recursive --line-width $(LINTING_LINELENGTH) $(PACKAGE_DIRECTORY) $(TEST_DIRECTORY)

darglint-test:
	darglint --docstring-style google --strictness full $(PACKAGE_DIRECTORY) $(TEST_DIRECTORY)

black-test:
	black \
		--check \
	 	--include "/($(PACKAGE_DIRECTORY)/|$(TEST_DIRECTORY)/).*\.pyi?" \
		--line-length $(LINTING_LINELENGTH) \
		.

black:
	black \
	--include "/($(PACKAGE_DIRECTORY)/|$(TEST_DIRECTORY)/).*\.pyi?" \
	--line-length $(LINTING_LINELENGTH) \
	.

pytest:
	python -m pytest \
		--verbose \
		--color=yes \
		--cov=$(PACKAGE_DIRECTORY) \
	  --cov-report term-missing

test: clean-pyc isort-test darglint-test black-test pytest

format: clean-pyc isort black

tox:
	tox

