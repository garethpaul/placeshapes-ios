.PHONY: build check lint native-test static-check test verify

override REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

check: verify

verify: static-check

lint: static-check

test: static-check

build: static-check

native-test: scripts/run-xcode-tests.sh
	"$(REPO_ROOT)/scripts/run-xcode-tests.sh"

static-check:
	python3 "$(REPO_ROOT)/scripts/check-baseline.py"
