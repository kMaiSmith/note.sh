#!/usr/bin/env bash
#
# notesh.action.sh - tools for executing note.sh actions
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

notesh.action.is_matching_file() {
    local action="${1}"; shift
    [[ "${1-}" == *"/${action}.action.sh" ]] || [ "${#}" -eq 0 ]
}

notesh.action.run() {
    local action="${1}"; shift
    local -a args=("${@}")

    # Valid action files have been loaded up into the NOTESH_ACTIONS list
    #   (see notesh.configs.sh@notesh.config.load_actions_folders() )
    set -- "${NOTESH_ACTIONS[@]}"
    until notesh.action.is_matching_file "${action}" "${@}"; do shift; done

    [ -n "${1-}" ] || {
        echo "${action}: Note action not found"
        exit 127
    }

    source "${1}"
    "${action}/notesh.run" "${args[@]}"
}