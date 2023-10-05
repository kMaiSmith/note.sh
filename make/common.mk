# common.mk - Common configurations for working with make
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

LOCAL_ROOT:=$(HOME)/.local
LOCAL_BIN:=$(LOCAL_ROOT)/bin
MAKE_ROOT:=$(PWD)/make
MAKE_BIN:=$(MAKE_ROOT)/bin

export PATH:=$(LOCAL_BIN):$(MAKE_BIN):$(PATH)
