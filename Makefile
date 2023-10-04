include .env

BINS=bin/note.sh
LIBS=$(wildcard lib/notesh/notesh.*.sh)
ACTIONS=$(wildcard lib/notesh/actions/*.action.sh)
CONFIGS=share/notesh/config.sh

VERSION=$(shell cat VERSION)
PROJECT_NAME=$(shell basename $(PWD))
ARCHIVE_NAME=$(PROJECT_NAME)-$(VERSION).tar.gz

BUILD_ROOT=./build
ARCHIVE=$(BUILD_ROOT)/$(ARCHIVE_NAME)

.env:
	touch $@

MANIFEST.md5: $(BINS) $(LIBS) $(ACTIONS) $(CONFIGS)
	md5sum $^ > $@

$(ARCHIVE): MANIFEST.md5 $(BINS) $(LIBS) $(ACTIONS) $(CONFIGS)
	mkdir -p $(BUILD_ROOT) && \
	tar -czf $@ $^ && \
	rm $<

build: $(ARCHIVE)

clean:
	rm -rf $(BUILD_ROOT)

publish: $(ARCHIVE)
	scp $^ $(PUBLISH_SERVER):$(PUBLISH_PATH)

.PHONY: bundle build clean publish