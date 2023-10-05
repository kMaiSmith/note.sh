# Makefile - note.sh CI/CD workflow entrypoint and definitions
#
# Copyright 2023 Kyle R Smith
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

include .env
include make/common.mk
include make/tools/shellcheck.mk
include make/tools/gh.mk
include make/tools/jq.mk

BINS=bin/note.sh
LIBS=$(wildcard lib/notesh/notesh.*.sh)
ACTIONS=$(wildcard lib/notesh/actions/*.action.sh)
CONFIGS=share/notesh/config.sh

VERSION_FILE:=VERSION
VERSION:=$(shell cat $(VERSION_FILE))

export CHANGELOG_FILE:=CHANGELOG.md
PROJECT_NAME=$(shell basename $(PWD))
ARCHIVE_NAME=$(PROJECT_NAME)-$(VERSION).tar.gz

BUILD_ROOT=./build
SHELL_FILES=$(BINS) $(LIBS) $(ACTIONS) $(CONFIGS)
ARCHIVE_FILES=$(SHELL_FILES) $(CHANGELOG_FILE)
ARCHIVE=$(BUILD_ROOT)/$(ARCHIVE_NAME)

export GIT_REPO=kmaismith/note.sh

.env:
	touch $@

MANIFEST.md5: $(ARCHIVE_FILES)
	md5sum $^ > $@

$(ARCHIVE): MANIFEST.md5 $(ARCHIVE_FILES)
	mkdir -p $(BUILD_ROOT) && \
	tar -czf $@ $^ && \
	rm $<

build: $(ARCHIVE)

shellcheck: $(SHELLCHECK) $(SHELL_FILES)
	$^

gitdiff_is_clean:
	git status;
	git diff-index --quiet HEAD --

GIT_BRANCH=$(shell git branch --show-current)
gitbranch_is_main:
	[ "$(GIT_BRANCH)" = "main" ]

ifeq ($(GIT_BRANCH),main)
BASE_REV:=$(shell git log --format=format:%H -- VERSION | head -n1)
version_is_updated: $(ARCHIVE_FILES)
	@git --no-pager diff $(BASE_REV) --name-only -- $^;
	git diff $(BASE_REV) --exit-code -s -- $^
else
BASE_REV:=$(shell git ls-remote | grep refs/heads/main | awk '{ print $$1 }')
version_is_updated: $(ARCHIVE_FILES)
	git fetch origin $(BASE_REV);
	git --no-pager diff $(BASE_REV) --name-only -- $^;
	git diff $(BASE_REV) --exit-code -s -- $^ || \
		! git diff $(BASE_REV) --exit-code -s -- $(VERSION_FILE)
endif

changelog_is_updated: $(CHANGELOG_FILE)
	grep -q "## $(VERSION)" $<

pr_check: shellcheck version_is_updated

publish_scp: $(ARCHIVE) pr_check gitbranch_is_main gitdiff_is_clean
	scp $< $(PUBLISH_SERVER):$(PUBLISH_PATH)

release_gitea: $(ARCHIVE) $(JQ) pr_check gitbranch_is_main gitdiff_is_clean
	gitea_api get_release "$(VERSION)" || \
		gitea_api create_release "$(VERSION)";
	gitea_api show_release_attachments | grep -q "$(ARCHIVE_NAME)" || \
		gitea_api create_release_attachment $(ARCHIVE)

release_github: $(ARCHIVE) $(GH) pr_check gitbranch_is_main gitdiff_is_clean
	$(GH) --repo $(GIT_REPO) release list | grep -q $(VERSION) || \
		$(GH) --repo $(GIT_REPO) release create $(VERSION) $(ARCHIVE) --draft \
			--notes "$$(changelog_utils body $(VERSION))" \
			--title "$$(changelog_utils title $(VERSION))"

clean:
	rm -rf $(BUILD_ROOT)

.PHONY: bundle build clean publish shellcheck gitdiff_is_clean \
	version_is_updated changelog_is_updated \
	publish_scp release_gitea release_github