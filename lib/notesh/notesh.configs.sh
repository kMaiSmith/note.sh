#!/usr/bin/env bash
#
# notesh.config.sh - Package config tools for note.sh
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

notesh.config.note_root() {
    [ -d "${NOTE_ROOT-}" ] && { echo "${NOTE_ROOT}"; return; }

    [ "${1}" = "/" ] && return
    [ -d "${1}/.notesh" ] && { echo "${1}"; return; }

    notesh.config.note_root "$(dirname "${1}")"
}

notesh.config.data_root() {
    set -- \
        "${NOTESH_DATA_ROOT-}" \
        "${HOME}/.local/share/notesh" \
        "${HOME}/.notesh"
    
    until [ -w "$(dirname "${1-}")" ] || [ "${#}" -eq 0 ]; do shift; done
    echo "${1-}"
}

notesh.config.load_actions_folders() {
    local -a folders actions
    readarray -td ':' folders < <(printf '%s' "${1}")

    for folder in "${folders[@]}"; do
        [ -d "${folder}" ] || continue
        readarray -t actions < <(find "${folder}" -name "*.action.sh")
    
        # In order for note.sh to run an action, a matching script file must
        #   be found in the NOTESH_ACTIONS list.
        #   (see notesh.actions.sh@notesh.action.run() )
        NOTESH_ACTIONS+=("${actions[@]}")
    done
}

notesh.config.load_user_config() {
    # The user can set a global config.sh to affect every note folder
    [ -f "${NOTESH_DATA_ROOT}/config.sh" ] && \
        source "${NOTESH_DATA_ROOT}/config.sh"

    # Individual note folders can have their own configs to override globals
    [ -f "${NOTESH_ROOT}/.notesh/config.sh" ] && \
        source "${NOTESH_ROOT}/.notesh/config.sh"
}

NOTE_ROOT="$(notesh.config.note_root "${PWD}")"
NOTESH_DATA_ROOT="$(notesh.config.data_root)"
NOTESH_ACTIONS=()
notesh.config.load_actions_folders \
    "${NOTESH_ACTIONS_PATH-}:${NOTESH_ROOT}/actions"
notesh.config.load_user_config

export NOTE_ROOT NOTESH_DATA_ROOT NOTESH_ACTIONS