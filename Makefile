.PHONY: help update-crds update-manifests validate lint install uninstall package clean

# Variables
CONTROLLER_DIR := ../controller
API_DIR := ../api
CHART_DIR := .
CRD_SOURCE_DIR := $(CONTROLLER_DIR)/config/crd/bases
CRD_DEST_DIR := $(CHART_DIR)/templates/crds
MANIFESTS_SOURCE_DIR := $(CONTROLLER_DIR)/config
CHART_NAME := lissto
NAMESPACE := lissto-system

# Colors for output
COLOR_RESET := \033[0m
COLOR_BOLD := \033[1m
COLOR_GREEN := \033[32m
COLOR_YELLOW := \033[33m
COLOR_BLUE := \033[34m

help: ## Show this help message
	@echo "$(COLOR_BOLD)Lissto Helm Chart Makefile$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BOLD)Available targets:$(COLOR_RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(COLOR_BLUE)%-20s$(COLOR_RESET) %s\n", $$1, $$2}'

update-crds: ## Update CRDs from controller directory
	@echo "$(COLOR_BOLD)$(COLOR_GREEN)Updating CRDs...$(COLOR_RESET)"
	@# First, generate CRDs in the controller directory
	@cd $(CONTROLLER_DIR) && $(MAKE) manifests
	@# Create CRD directory if it doesn't exist
	@mkdir -p $(CRD_DEST_DIR)
	@# Remove old CRDs
	@rm -f $(CRD_DEST_DIR)/*.yaml
	@# Copy new CRDs and wrap them with conditional
	@for crd in $(CRD_SOURCE_DIR)/*.yaml; do \
		filename=$$(basename $$crd); \
		echo "  Copying $$filename..."; \
		echo "{{- if .Values.crds.install }}" > $(CRD_DEST_DIR)/$$filename; \
		cat $$crd >> $(CRD_DEST_DIR)/$$filename; \
		echo "{{- end }}" >> $(CRD_DEST_DIR)/$$filename; \
	done
	@echo "$(COLOR_GREEN)✓ CRDs updated successfully$(COLOR_RESET)"

update-manifests: update-crds ## Update all manifests (CRDs and other resources)
	@echo "$(COLOR_BOLD)$(COLOR_GREEN)Updating manifests...$(COLOR_RESET)"
	@echo "$(COLOR_GREEN)✓ Manifests updated successfully$(COLOR_RESET)"

validate: ## Validate the Helm chart
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Validating Helm chart...$(COLOR_RESET)"
	@helm lint $(CHART_DIR)
	@echo "$(COLOR_GREEN)✓ Chart validation passed$(COLOR_RESET)"

lint: validate ## Alias for validate

template: ## Generate Kubernetes manifests from the chart
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Generating templates...$(COLOR_RESET)"
	@helm template $(CHART_NAME) $(CHART_DIR) --namespace $(NAMESPACE)

template-file: ## Generate Kubernetes manifests to a file
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Generating templates to lissto-manifests.yaml...$(COLOR_RESET)"
	@helm template $(CHART_NAME) $(CHART_DIR) --namespace $(NAMESPACE) > lissto-manifests.yaml
	@echo "$(COLOR_GREEN)✓ Manifests written to lissto-manifests.yaml$(COLOR_RESET)"

install: ## Install the Helm chart
	@echo "$(COLOR_BOLD)$(COLOR_GREEN)Installing Helm chart...$(COLOR_RESET)"
	@helm install $(CHART_NAME) $(CHART_DIR) --namespace $(NAMESPACE) --create-namespace
	@echo "$(COLOR_GREEN)✓ Chart installed successfully$(COLOR_RESET)"

upgrade: ## Upgrade the Helm chart
	@echo "$(COLOR_BOLD)$(COLOR_YELLOW)Upgrading Helm chart...$(COLOR_RESET)"
	@helm upgrade $(CHART_NAME) $(CHART_DIR) --namespace $(NAMESPACE) --install --create-namespace
	@echo "$(COLOR_GREEN)✓ Chart upgraded successfully$(COLOR_RESET)"

uninstall: ## Uninstall the Helm chart
	@echo "$(COLOR_BOLD)$(COLOR_YELLOW)Uninstalling Helm chart...$(COLOR_RESET)"
	@helm uninstall $(CHART_NAME) --namespace $(NAMESPACE)
	@echo "$(COLOR_GREEN)✓ Chart uninstalled successfully$(COLOR_RESET)"

package: validate ## Package the Helm chart
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Packaging Helm chart...$(COLOR_RESET)"
	@helm package $(CHART_DIR)
	@echo "$(COLOR_GREEN)✓ Chart packaged successfully$(COLOR_RESET)"

clean: ## Clean generated files
	@echo "$(COLOR_BOLD)$(COLOR_YELLOW)Cleaning generated files...$(COLOR_RESET)"
	@rm -f *.tgz
	@rm -f lissto-manifests.yaml
	@echo "$(COLOR_GREEN)✓ Cleaned successfully$(COLOR_RESET)"

test-controller: ## Test with controller only
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Testing controller deployment...$(COLOR_RESET)"
	@helm template $(CHART_NAME) $(CHART_DIR) \
		--set api.enabled=false \
		--set bot.enabled=false \
		--namespace $(NAMESPACE)

test-api: ## Test with API only
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Testing API deployment...$(COLOR_RESET)"
	@helm template $(CHART_NAME) $(CHART_DIR) \
		--set controller.enabled=false \
		--set bot.enabled=false \
		--namespace $(NAMESPACE)

test-bot: ## Test with bot only
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Testing bot deployment...$(COLOR_RESET)"
	@helm template $(CHART_NAME) $(CHART_DIR) \
		--set controller.enabled=false \
		--set api.enabled=false \
		--namespace $(NAMESPACE)

test-all-disabled: ## Test with all components disabled
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Testing with all components disabled...$(COLOR_RESET)"
	@helm template $(CHART_NAME) $(CHART_DIR) \
		--set controller.enabled=false \
		--set api.enabled=false \
		--set bot.enabled=false \
		--set config.enabled=false \
		--namespace $(NAMESPACE)

dry-run: ## Perform a dry-run installation
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Performing dry-run installation...$(COLOR_RESET)"
	@helm install $(CHART_NAME) $(CHART_DIR) \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--dry-run --debug

values: ## Show all values
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Chart values:$(COLOR_RESET)"
	@helm show values $(CHART_DIR)

docs: ## Generate documentation
	@echo "$(COLOR_BOLD)$(COLOR_BLUE)Generating documentation...$(COLOR_RESET)"
	@helm-docs || echo "$(COLOR_YELLOW)helm-docs not installed. Install with: brew install norwoodj/tap/helm-docs$(COLOR_RESET)"

# Quick commands for common workflows
quick-update: update-crds validate ## Quick update: regenerate CRDs and validate
	@echo "$(COLOR_GREEN)✓ Quick update completed$(COLOR_RESET)"

quick-install: quick-update install ## Quick install: update and install
	@echo "$(COLOR_GREEN)✓ Quick install completed$(COLOR_RESET)"

quick-upgrade: quick-update upgrade ## Quick upgrade: update and upgrade
	@echo "$(COLOR_GREEN)✓ Quick upgrade completed$(COLOR_RESET)"

