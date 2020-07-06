.PHONY: lint validate

all: lint validate

lint:
	.scripts/lint.sh

validate:
	.scripts/validate.sh
