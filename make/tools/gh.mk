# tools/gh.mk - Tool install definitions for installing the GitHub API
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

ifeq ($(INC_TOOLS_COMMON),)
include $(MAKE_ROOT)/tools/common.mk
endif

GH=$(shell command -v gh)

ifeq ($(GH),)
GH=$(LOCAL_BIN)/gh
GH_EXTRACT_ROOT=$(TOOL_EXTRACT_ROOT)/gh
GH_VERSION=2.36.0
# As per https://github.com/cli/cli/releases/tag/v2.36.0
GH_ARCHIVE=gh_$(GH_VERSION)_linux_$(ARCH_COLLOQUIAL).tar.gz
GH_URL_BASE=https://github.com/cli/cli/releases/download

$(GH_EXTRACT_ROOT):
	mkdir -p $@

$(GH_EXTRACT_ROOT)/$(GH_ARCHIVE): $(GH_EXTRACT_ROOT)
	wget -O $@ $(GH_URL_BASE)/v$(GH_VERSION)/$(GH_ARCHIVE)

$(GH_EXTRACT_ROOT)/bin/gh: $(GH_EXTRACT_ROOT)/$(GH_ARCHIVE)
	tar -xf $< --strip-components=1 -C $(GH_EXTRACT_ROOT)

ifneq ($(MANDB),)
gh_mandb:
	cp -rf $(GH_EXTRACT_ROOT)/share $(LOCAL_ROOT);
	$(MANDB) -su $(LOCAL_ROOT)/share/man
endif

$(GH): $(GH_EXTRACT_ROOT)/bin/gh $(LOCAL_BIN) gh_mandb
	cp $< $@;
	rm -rf $(GH_EXTRACT_ROOT)

.PHONY: gh_mandb
endif