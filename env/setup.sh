#
# Copyright 2023, Colias Group, LLC
#
# SPDX-License-Identifier: BSD-2-Clause
#

set -eu -o pipefail

# . ~/.nix-profile/etc/profile.d/nix.sh

here=$(dirname $0)

activationPackage=$(nix-build $here -A activationPackage --no-out-link)

nix-env -ir $activationPackage/home-path
$activationPackage/activate
