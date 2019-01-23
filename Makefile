
ifdef TRAVIS_TAG
PRESENTATION_URL ?= https://containous.github.io/slides/$(TRAVIS_TAG)
else
	ifneq ($(TRAVIS_BRANCH), master)
	PRESENTATION_URL ?= https://containous.github.io/slides/$(TRAVIS_BRANCH)
	else
	PRESENTATION_URL ?= https://containous.github.io/slides
	endif
endif
export PRESENTATION_URL

all: clean build verify

# Generate documents inside a container, all *.adoc in parallel
build: clean
	@docker-compose up \
		--build \
		--force-recreate \
		--exit-code-from build \
	build

verify: verify-links verify-w3c

verify-links:
	@docker run --rm \
		-v $(CURDIR)/dist:/dist \
		18fgsa/html-proofer \
			--check-html \
			--http-status-ignore "999" \
			--url-ignore "/localhost:/,/127.0.0.1:/,/$(PRESENTATION_URL)/,/traefik-demo.containous.cloud/" \
        	/dist/index.html

verify-w3c:
	docker run --rm -v $(CURDIR)/dist:/app stratdat/html5validator

serve: clean
	@docker-compose up --build --force-recreate serve

shell:
	@docker-compose up --build --force-recreate -d serve
	@docker-compose exec serve sh

deploy:
	@bash $(CURDIR)/scripts/travis-gh-deploy.sh

clean: chmod
	@docker-compose down -v --remove-orphans
	rm -rf $(CURDIR)/dist $(CURDIR)/docs

qrcode:
	@docker-compose up --build --force-recreate qrcode

chmod:
	@docker run --rm -t -v $(CURDIR):/app \
		alpine chown -R "$$(id -u):$$(id -g)" /app

.PHONY: all build verify verify-links verify-w3c serve deploy qrcode chmod
