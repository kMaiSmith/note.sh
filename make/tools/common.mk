# tools/common.mk - Common configurations for external tool fetching
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

INC_TOOLS_COMMON=true

TOOL_EXTRACT_ROOT=$(LOCAL_ROOT)/tmp/install

MANDB=$(shell command -v mandb)
ARCH=$(shell uname -m)
ifeq ($(ARCH),x86_64)
ARCH_COLLOQUIAL=amd64
endif

$(LOCAL_ROOT) $(LOCAL_BIN) $(TOOL_EXTRACT_ROOT):
	mkdir -p $@
