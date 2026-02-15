.PHONY: help setup generate validate clean

# Configuration
VAULT_NAME ?= my-study-vault
TOPIC ?= "Your Study Topic"
CONTEXT ?= 
LANGUAGE ?= en
OUTPUT_DIR ?= ./generated-vaults

# Colors
GREEN  := \033[0;32m
YELLOW := \033[1;33m
BLUE   := \033[0;34m
RED    := \033[0;31m
NC     := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║                                                            ║$(NC)"
	@echo "$(BLUE)║         Obsidian Vault Generator (Zettelkasten)           ║$(NC)"
	@echo "$(BLUE)║              AI-Powered Study Vault Creation               ║$(NC)"
	@echo "$(BLUE)║                                                            ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Usage examples:$(NC)"
	@echo "  make generate TOPIC=\"Kubernetes\"          # Generate complete vault with AI"
	@echo "  make generate TOPIC=\"Kubernetes\" LANGUAGE=pt  # Generate in Portuguese"
	@echo "  make prompt-only TOPIC=\"GraphQL APIs\"     # Print prompt to terminal only"
	@echo "  make validate VAULT_NAME=my-vault         # Validate existing vault"
	@echo ""
	@echo "$(GREEN)Configuration variables:$(NC)"
	@echo "  TOPIC        Study topic (required for generate/prompt-only)"
	@echo "  CONTEXT      Context name (optional, auto-generated from TOPIC)"
	@echo "  LANGUAGE     Output language code (default: en) (e.g., pt, es, fr, de)"
	@echo "  OUTPUT_DIR   Output directory (default: ./generated-vaults)"
	@echo "  VAULT_NAME   Vault name for validation (default: my-study-vault)"
	@echo ""

setup: ## Setup project (create output directory)
	@echo "$(BLUE)Setting up project structure...$(NC)"
	@mkdir -p $(OUTPUT_DIR)
	@mkdir -p scripts
	@echo "$(GREEN)✅ Setup complete!$(NC)"

generate: setup ## Generate complete vault with AI content (requires TOPIC)
	@if [ -z "$(TOPIC)" ]; then \
		echo "$(RED)Error: TOPIC is required$(NC)"; \
		echo "Usage: make generate TOPIC=\"Your Topic\""; \
		exit 1; \
	fi
	@echo "$(BLUE)Generating vault for topic: $(TOPIC)$(NC)"
	@if [ -n "$(CONTEXT)" ]; then \
		./scripts/generate-vault.sh --topic "$(TOPIC)" --context "$(CONTEXT)" --lang "$(LANGUAGE)" --output $(OUTPUT_DIR); \
	else \
		./scripts/generate-vault.sh --topic "$(TOPIC)" --lang "$(LANGUAGE)" --output $(OUTPUT_DIR); \
	fi

prompt-only: setup ## Print optimized prompt to terminal only (requires TOPIC)
	@if [ -z "$(TOPIC)" ]; then \
		echo "$(RED)Error: TOPIC is required$(NC)"; \
		echo "Usage: make prompt-only TOPIC=\"Your Topic\""; \
		exit 1; \
	fi
	@echo "$(BLUE)Generating optimized prompt for: $(TOPIC)$(NC)"
	@if [ -n "$(CONTEXT)" ]; then \
		./scripts/generate-vault.sh --topic "$(TOPIC)" --context "$(CONTEXT)" --lang "$(LANGUAGE)" --prompt-only; \
	else \
		./scripts/generate-vault.sh --topic "$(TOPIC)" --lang "$(LANGUAGE)" --prompt-only; \
	fi

validate: ## Validate generated vault (requires VAULT_NAME)
	@if [ ! -d "$(OUTPUT_DIR)/$(VAULT_NAME)" ]; then \
		echo "$(RED)Error: Vault not found at $(OUTPUT_DIR)/$(VAULT_NAME)$(NC)"; \
		echo "Available vaults:"; \
		ls -d $(OUTPUT_DIR)/*/ 2>/dev/null | xargs -n 1 basename || echo "  (none)"; \
		exit 1; \
	fi
	@./scripts/generate-vault.sh --validate --output "$(OUTPUT_DIR)/$(VAULT_NAME)"

list-vaults: ## List all generated vaults
	@echo "$(BLUE)Generated vaults in $(OUTPUT_DIR):$(NC)"
	@if [ -d "$(OUTPUT_DIR)" ]; then \
		ls -d $(OUTPUT_DIR)/*/ 2>/dev/null | xargs -n 1 basename || echo "$(YELLOW)No vaults found$(NC)"; \
	else \
		echo "$(YELLOW)Output directory does not exist$(NC)"; \
	fi

clean: ## Remove all generated vaults
	@echo "$(YELLOW)⚠️  This will delete all vaults in $(OUTPUT_DIR)$(NC)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -rf $(OUTPUT_DIR); \
		echo "$(GREEN)✅ Cleaned up generated vaults$(NC)"; \
	else \
		echo "$(BLUE)Cancelled$(NC)"; \
	fi

test-prompt: ## Test prompt optimization with example topic
	@echo "$(BLUE)Testing prompt optimization with example topic: 'Docker Containerization'$(NC)"
	@./scripts/generate-vault.sh --topic "Docker Containerization" --prompt-only

example-k8s: setup ## Generate example Kubernetes study vault
	@$(MAKE) generate TOPIC="Kubernetes" CONTEXT="Kubernetes" LANGUAGE="$(LANGUAGE)"

example-ml: setup ## Generate example Machine Learning study vault
	@$(MAKE) generate TOPIC="Machine Learning" CONTEXT="MachineLearning" LANGUAGE="$(LANGUAGE)"

example-graphql: setup ## Generate example GraphQL APIs study vault
	@$(MAKE) generate TOPIC="GraphQL APIs" CONTEXT="GraphQL" LANGUAGE="$(LANGUAGE)"

stats: ## Show statistics about generated vaults
	@echo "$(BLUE)Vault Statistics:$(NC)"
	@echo ""
	@if [ -d "$(OUTPUT_DIR)" ]; then \
		vault_count=$$(ls -d $(OUTPUT_DIR)/*/ 2>/dev/null | wc -l); \
		echo "$(GREEN)Total vaults: $$vault_count$(NC)"; \
		echo ""; \
		for vault in $(OUTPUT_DIR)/*/; do \
			if [ -d "$$vault" ]; then \
				vault_name=$$(basename "$$vault"); \
				permanent_notes=$$(find "$$vault/10-CONTEXTS" -name "*.md" 2>/dev/null | wc -l); \
				study_plans=$$(find "$$vault/20-STUDY-PLANS" -name "*.md" 2>/dev/null | wc -l); \
				echo "$(YELLOW)$$vault_name:$(NC)"; \
				echo "  Permanent notes: $$permanent_notes"; \
				echo "  Study plans: $$study_plans"; \
				echo ""; \
			fi \
		done \
	else \
		echo "$(YELLOW)No vaults found$(NC)"; \
	fi

update-readme: ## Update README.md with latest usage instructions
	@echo "$(BLUE)README.md is up to date!$(NC)"
	@echo "Current stats:"
	@echo "  .instructions: $$(wc -l < .instructions) lines"
	@echo "  .zettelkasten: $$(wc -l < .zettelkasten) lines"
	@echo "  README.md: $$(wc -l < README.md) lines"
	@echo "  .obsidian/ files: $$(find .obsidian -type f | wc -l)"

version: ## Show project version info
	@echo "$(BLUE)Obsidian Vault Generator$(NC)"
	@echo "Version: 1.0.0"
	@echo "License: MIT"
	@echo ""
	@echo "Files:"
	@echo "  .instructions: $$(wc -l < .instructions) lines"
	@echo "  .zettelkasten: $$(wc -l < .zettelkasten) lines"
	@echo "  README.md: $$(wc -l < README.md) lines"
	@echo "  .obsidian/: $$(find .obsidian -type f | wc -l) files"
	@echo ""
