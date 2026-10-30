SHELL := /bin/bash

PROJECT_ROOT := $(shell git rev-parse --show-toplevel)
VENV_BIN     := $(PROJECT_ROOT)/.venv/bin
STAGING_INFRA_ENV  := $(PROJECT_ROOT)/opentofu/envs/staging.infra.sops.env
STAGING_SHARED_ENV  := $(PROJECT_ROOT)/opentofu/envs/staging.shared.sops.env
PROD_RUNNER_ENV  := $(PROJECT_ROOT)/opentofu/envs/prod.runner.sops.env
PROD_SHARED_ENV  := $(PROJECT_ROOT)/opentofu/envs/prod.shared.sops.env

.PHONY: install encrypt tofu\:plan\:infra\:staging tofu\:apply\:infra\:staging tofu\:plan\:infra\:prod tofu\:apply\:infra\:prod tofu\:plan\:runner\:prod tofu\:apply\:runner\:prod ansible\:infra\:staging ansible\:infra\:prod ansible\:runner\:prod

install:
	@cd $(PROJECT_ROOT)/scripts && ./install.sh
encrypt:
	@cd $(PROJECT_ROOT)/scripts && ./encrypt.sh


ARGS ?=
TARGET ?=
AUTO_APPROVE ?= 0
OUT ?=
PLAN ?=

TOFU_PLAN_FLAGS = $(ARGS)
ifneq ($(TARGET),)
	TOFU_PLAN_FLAGS += -target=$(TARGET)
endif
ifneq ($(OUT),)
	TOFU_PLAN_FLAGS += -out=$(OUT)
endif

TOFU_APPLY_FLAGS = $(ARGS)
ifeq ($(AUTO_APPROVE),1)
	TOFU_APPLY_FLAGS += -auto-approve
endif
ifneq ($(TARGET),)
	TOFU_APPLY_FLAGS += -target=$(TARGET)
endif

# <tool>:<action>:<domain>:<env>
tofu\:plan\:infra\:staging:
	@cd $(PROJECT_ROOT)/opentofu/infra/staging && $(VENV_BIN)/tofu plan -var-file=<(sops -d $(STAGING_INFRA_ENV)) -var-file=<(sops -d $(STAGING_SHARED_ENV)) $(TOFU_PLAN_FLAGS)

# <tool>:<action>:<domain>:<env>
tofu\:apply\:infra\:staging:
	@cd $(PROJECT_ROOT)/opentofu/infra/staging && \
		if [ -n "$(PLAN)" ]; then \
		echo "Applying saved plan: $(PLAN)"; \
		$(VENV_BIN)/tofu apply $(PLAN); \
		else \
		$(VENV_BIN)/tofu apply -var-file=<(sops -d $(STAGING_INFRA_ENV)) -var-file=<(sops -d $(STAGING_SHARED_ENV)) $(TOFU_APPLY_FLAGS); \
		fi

# <tool>:<action>:<domain>:<env>
tofu\:plan\:infra\:prod:
	@cd $(PROJECT_ROOT)/opentofu/infra/prod && $(VENV_BIN)/tofu plan -var-file=<(sops -d $(STAGING_INFRA_ENV)) -var-file=<(sops -d $(STAGING_SHARED_ENV)) $(TOFU_PLAN_FLAGS)

# <tool>:<action>:<domain>:<env>
tofu\:apply\:infra\:prod:
	@cd $(PROJECT_ROOT)/opentofu/infra/prod && \
		if [ -n "$(PLAN)" ]; then \
		echo "Applying saved plan: $(PLAN)"; \
		$(VENV_BIN)/tofu apply $(PLAN); \
		else \
		$(VENV_BIN)/tofu apply -var-file=<(sops -d $(STAGING_INFRA_ENV)) -var-file=<(sops -d $(STAGING_SHARED_ENV)) $(TOFU_APPLY_FLAGS); \
		fi

# <tool>:<action>:<domain>:<env>
tofu\:plan\:runner\:prod:
	@cd $(PROJECT_ROOT)/opentofu/runner && $(VENV_BIN)/tofu plan -var-file=<(sops -d $(PROD_RUNNER_ENV)) -var-file=<(sops -d $(PROD_SHARED_ENV)) $(TOFU_PLAN_FLAGS)

# <tool>:<action>:<domain>:<env>
tofu\:apply\:runner\:prod:
	@cd $(PROJECT_ROOT)/opentofu/runner && \
		if [ -n "$(PLAN)" ]; then \
		echo "Applying saved plan: $(PLAN)"; \
		$(VENV_BIN)/tofu apply $(PLAN); \
		else \
		$(VENV_BIN)/tofu apply -var-file=<(sops -d $(PROD_RUNNER_ENV)) -var-file=<(sops -d $(PROD_SHARED_ENV)) $(TOFU_APPLY_FLAGS); \
		fi

# <tool>:<domain>:<env>
ansible\:infra\:staging:
	@cd $(PROJECT_ROOT)/ansible && $(VENV_BIN)/ansible-playbook -i inventories/staging/inventory.ini infra_playbook.yml
	#
	# <tool>:<domain>:<env>
	ansible\:infra\:prod:
	@cd $(PROJECT_ROOT)/ansible && $(VENV_BIN)/ansible-playbook -i inventories/prod/inventory.ini infra_playbook.yml

# //TODO
# <tool>:<domain>
ansible\:runner\:prod:
	@cd $(PROJECT_ROOT)/ansible && $(VENV_BIN)/ansible-playbook -i inventories/prod/runner_inventory.ini runner_playbook.yml
