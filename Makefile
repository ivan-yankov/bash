# Development tasks for the command package.
#
# The commands themselves need no build step; these targets are for checking
# the package before committing.

.PHONY: help test test-local test-matrix lint shell check

help:
	@echo "test         run the suite in a container (the meaningful one)"
	@echo "test-local   run the suite directly on this machine"
	@echo "test-matrix  run the suite against every supported distribution"
	@echo "lint         check the command declarations"
	@echo "shell        open a shell inside the test container"
	@echo "check        lint + containerised tests"
	@echo
	@echo "Pass a filter through to the runner with F=<name>, e.g. make test F=archive"

# The container run is the one that counts: it has none of the developer's
# ~/.bash, and mounts the repo read-only.
test:
	@python3 ci/run-tests.py $(F)

test-local:
	@./test/runner.sh $(F)

test-matrix:
	@python3 ci/run-tests.py --matrix $(F)

lint:
	@python3 tools/lint-cmds.py

shell:
	@python3 ci/run-tests.py --shell

check: lint test
