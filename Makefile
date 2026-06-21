.PHONY: build check lint native-test root-test static-check test verify

override SHELL := /bin/sh
override .SHELLFLAGS := -c
ifneq ($(strip $(MAKEFILES)),)
$(error MAKEFILES must not be set)
endif
override MAKEFILES :=
ifneq ($(origin MAKEFILE_LIST),file)
$(error MAKEFILE_LIST must not be overridden)
endif
override REPO_ROOT := $(shell MAKEFILE_LIST_RAW='$(subst ','"'"',$(MAKEFILE_LIST))' python3 -c "import os, shlex; raw = os.environ['MAKEFILE_LIST_RAW']; candidates = [raw] + [raw[index + 1:] for index, char in enumerate(raw) if char == ' ']; path = next((candidate for candidate in candidates if (candidate == 'Makefile' or candidate.endswith('/Makefile')) and os.path.isfile(os.path.abspath(candidate))), None); assert path is not None, 'trusted Makefile path not found'; print(shlex.quote(os.path.dirname(os.path.realpath(path))))")
override PYTHON := python3
build check lint native-test root-test static-check test verify: override REPO_ROOT := $(REPO_ROOT)
build check lint native-test root-test static-check test verify: override PYTHON := $(PYTHON)

check: verify

verify: static-check root-test

lint: static-check

test: static-check

build: static-check

native-test:
	$(REPO_ROOT)/scripts/run-xcode-tests.sh

root-test:
	$(PYTHON) $(REPO_ROOT)/scripts/test-makefile-root.py

static-check:
	$(PYTHON) $(REPO_ROOT)/scripts/check-baseline.py
