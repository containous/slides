CURRENT_UID = $(shell id -u):$(shell id -g)
DIST_DIR ?= $(CURRENT_DIR)/dist
ifdef TRAVIS_TAG
PRESENTATION_URL ?= https://containous.github.io/slides/$(TRAVIS_TAG)
else
	ifneq ($(TRAVIS_BRANCH), master)
	PRESENTATION_URL ?= https://containous.github.io/slides/$(TRAVIS_BRANCH)
	else
	PRESENTATION_URL ?= https://containous.github.io/slides
	endif
endif
export PRESENTATION_URL CURRENT_UID


all: clean build verify

# Generate documents inside a container, all *.adoc in parallel
build: clean $(DIST_DIR)
	ls -la $(DIST_DIR)
	@docker-compose up \
		--build \
		--force-recreate \
		--exit-code-from build \
	build

$(DIST_DIR):
	mkdir -p $(DIST_DIR)

verify:
	@docker run --rm \
		-v $(CURDIR)/dist:/dist \
		--user $(CURRENT_UID) \
		18fgsa/html-proofer \
			--check-html \
			--http-status-ignore "999" \
			--url-ignore "/localhost:/,/127.0.0.1:/,/$(PRESENTATION_URL)/,/.containous.cloud/" \
        	/dist/index.html

serve: clean
	@docker-compose up --build --force-recreate serve

shell:
	@docker-compose up --build --force-recreate -d serve
	@docker-compose exec serve sh

$(CURDIR)/dist/index.html: build

pdf: $(CURDIR)/dist/index.html
	ls -la $(DIST_DIR)
	@docker run --rm -t -v $(CURDIR)/dist:/slides astefanutti/decktape:2.9 \
		--user $(CURRENT_UID) \
		/slides/index.html \
		/slides/slides.pdf \
		--size='2048x1536'

deploy: pdf
	@bash $(CURDIR)/scripts/travis-gh-deploy.sh

clean: chmod
	@docker-compose down -v --remove-orphans
	rm -rf $(CURDIR)/dist

qrcode:
	@docker-compose up --build --force-recreate qrcode

chmod:
	@docker run --rm -t -v $(CURDIR):/app \
		alpine chown -R "$$(id -u):$$(id -g)" /app

.PHONY: all build verify serve deploy qrcode chmod pdf
