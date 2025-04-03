REPO ?=
REPO_NAME := $(notdir $(REPO))
TEMP_DIR := temp-$(REPO_NAME)
DEST_DIR := $(REPO_NAME)

.PHONY: add update clean

add:
	@if [ -z "$(REPO)" ]; then \
		echo "❌ Usage: make add REPO=user/repo"; \
		exit 1; \
	fi
	@echo "📦 Adding project $(REPO_NAME)..."
	git clone --filter=blob:none --sparse https://github.com/$(REPO).git $(TEMP_DIR)
	cd $(TEMP_DIR) && git sparse-checkout set docs
	mkdir -p $(DEST_DIR)
	cp -r $(TEMP_DIR)/docs/* $(DEST_DIR)/
	@$(MAKE) clean
	@echo "✅ Added $(DEST_DIR)/ from $(REPO)"

update:
	@if [ -z "$(REPO)" ]; then \
		echo "❌ Usage: make update REPO=user/repo"; \
		exit 1; \
	fi
	@echo "🔄 Updating project $(REPO_NAME)..."
	rm -rf $(TEMP_DIR)
	git clone --filter=blob:none --sparse https://github.com/$(REPO).git $(TEMP_DIR)
	cd $(TEMP_DIR) && git sparse-checkout set docs
	rm -rf $(DEST_DIR)/*
	cp -r $(TEMP_DIR)/docs/* $(DEST_DIR)/
	@$(MAKE) clean
	@echo "✅ Updated $(DEST_DIR)/ from $(REPO)"

clean:
	rm -rf $(TEMP_DIR)
