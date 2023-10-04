#!/usr/bin/env bash
#
# today.action.sh - Managing daily notes action for note.sh
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

today/notesh.run() {
    local day_file day_root="${NOTE_ROOT}/Days"
    day_file="${day_root}/$(date +%F-W%V%a).md"

    mkdir -p "${day_root}"
    [ -f "${day_file}" ] || today.generate.day_file "${day_file}"

    notesh.action.run edit "${day_file}"
}

today.generate.day_file() {
    cp "$(today.template_file)" "${1}"
}

today.template_file() {
    local template_root="${NOTE_ROOT}/Templates"
    local template_file="${template_root}/Day.md"

    mkdir -p "${template_root}"
    [ -f "${template_file}" ] || \
        cat <<DAY_TEMPLATE >> "${template_file}"
# Today: ####-##-##

DAY_TEMPLATE

    echo "${template_file}"
}