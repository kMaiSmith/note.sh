#!/usr/bin/env bash
#
# shell.action.sh - Shell for invoking note.sh commands
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

shell/notesh.run() {
    [[ "${PWD}/" == "${NOTE_ROOT}/"* ]] || cd "${NOTE_ROOT}" || \
        echo "Could not enter ${NOTE_ROOT}, sticking with ${PWD}"

    while read -r -a NOTECOMMAND -p "$(shell.prompt)"; do
        set -- "${NOTECOMMAND[@]}"

        [ "${1-}" = "exit" ] && break
        [ "${#}" -gt 0 ] && ( notesh.action.run "${@}"; )
    done
}

shell.prompt() {
    echo "note.sh @ $(basename "${NOTE_ROOT}"): ${PWD/${NOTE_ROOT}/}/ > "
}