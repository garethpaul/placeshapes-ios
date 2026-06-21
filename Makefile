.PHONY: build check lint native-test root-test static-check test verify

ifneq ($(origin MAKEFILE_LIST),file)
$(error MAKEFILE_LIST must not be overridden)
endif
override REPO_ROOT := $(shell path='$(subst ','"'"',$(MAKEFILE_LIST))'; path=$$(printf '%s' "$$path" | /usr/bin/sed 's/^ //'); directory=$$(/usr/bin/dirname -- "$$path"); CDPATH= cd -- "$$directory" && /bin/pwd -P)

check: verify

verify: static-check root-test

lint: static-check

test: static-check

build: static-check

native-test:
	"$(REPO_ROOT)/scripts/run-xcode-tests.sh"

static-check:
	python3 "$(REPO_ROOT)/scripts/check-baseline.py"

root-test:
	PYTHONDONTWRITEBYTECODE=1 python3 "$(REPO_ROOT)/scripts/test-makefile-root.py"
