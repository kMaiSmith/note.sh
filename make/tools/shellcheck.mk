# tools/common.mk - Tool install definitions for working with shellcheck
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

SHELLCHECK=$(shell command -v shellcheck)

ifeq ($(SHELLCHECK),)

SHELLCHECK=$(LOCAL_BIN)/shellcheck
SHELLCHECK_EXTRACT_ROOT=$(TOOL_EXTRACT_ROOT)/shellcheck
SHELLCHECK_VERSION=v0.9.0
# As per https://github.com/koalaman/shellcheck/releases/tag/v0.9.0
SHELLCHECK_ARCHIVE=shellcheck-$(SHELLCHECK_VERSION).linux.$(ARCH).tar.xz
SHELLCHECK_URL_BASE=https://github.com/koalaman/shellcheck/releases/download

$(SHELLCHECK_EXTRACT_ROOT):
	mkdir -p $@

$(SHELLCHECK_EXTRACT_ROOT)/$(SHELLCHECK_ARCHIVE): $(SHELLCHECK_EXTRACT_ROOT)
	wget -O $@ $(SHELLCHECK_URL_BASE)/$(SHELLCHECK_VERSION)/$(SHELLCHECK_ARCHIVE)

$(SHELLCHECK_EXTRACT_ROOT)/shellcheck: $(SHELLCHECK_EXTRACT_ROOT)/$(SHELLCHECK_ARCHIVE)
	tar -xf $< --strip-components=1 -C $(SHELLCHECK_EXTRACT_ROOT)

$(SHELLCHECK): $(SHELLCHECK_EXTRACT_ROOT)/shellcheck $(LOCAL_BIN)
	cp $< $@;
	rm -rf $(SHELLCHECK_EXTRACT_ROOT)

endif