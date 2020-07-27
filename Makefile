# HPC Project
# Mirrors suggested techniques at:
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# Further discussion at:
# https://news.ycombinator.com/item?id=11195539

PROJECT_NAME ?= "hpc"
GH_USER ?= "coatless"
LIVE_DOMAIN ?= "https://hpc.thecoatlessprofessor.com"
VERSION ?= 0.5.0
LOCAL_PORT ?= 8001

# Help ------------------------------------------------------------------------

.PHONY: help
help:  ## Makefile help documentation
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

# Preview ---------------------------------------------------------------------

.PHONY: serve
serve:  ## Serve and regenerate documentation locally under mkdocs
	@mkdocs serve --dev-addr=0.0.0.0:${LOCAL_PORT}

.PHONY: open
open:  ## Open locally generated documentation in-browser
	@open http://127.0.0.1:${LOCAL_PORT}

# Build -----------------------------------------------------------------------

.PHONY: build-site
build-site:  ## Build site
	@mkdocs build

.PHONY: clean-site
clean-site:  ## Clean site
	@mkdocs build  --clean

# Site ------------------------------------------------------------------------

.PHONY: site-open
site-open:  ## Open the published documentation in browser
	@open ${LIVE_DOMAIN}

.PHONY: site-url
site-url:  ## Print URL of the published documentation
	@echo ${LIVE_DOMAIN}

# Repo ------------------------------------------------------------------------

.PHONY: repo-open
open-repo:  ## Open URL of project GitHub page
	@open https://github.com/${GH_USER}/${PROJECT_NAME}

.PHONY: repo-url
url-repo:  ## Display URL of project GitHub page
	@echo https://github.com/${GH_USER}/${PROJECT_NAME}

# Release ---------------------------------------------------------------------

.PHONY: release
release:  ## Publish documentation onto GitHub Pages
	@mkdocs gh-deploy --force
