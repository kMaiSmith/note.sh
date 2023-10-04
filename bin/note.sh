#!/usr/bin/env bash
#
# note.sh - Personal note management script
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

usage() {
    cat <<USAGE
$(basename "${0}") <ACTION>

    Valid actions:
USAGE
    for action in "${NOTESH_ACTIONS[@]}"; do
        echo "      $(basename "${action/\.action\.sh/}")"
    done

    exit 1
}

set -o nounset  # -u
set -o pipefail
# set -o errexit  # -e

NOTESH_ROOT="$(cd "$(dirname "${0}")/../lib/notesh" || exit 1; pwd)"
export NOTESH_ROOT

source "${NOTESH_ROOT}/notesh.configs.sh"
source "${NOTESH_ROOT}/notesh.actions.sh"

if [ "${0}" = "${BASH_SOURCE[0]}" ]; then
    notesh.action.run "${@-shell}"
fi