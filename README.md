# sedutil
sedutil is for setting up and using self encrypting drives (SEDs) that
comply with the TCG OPAL 2.00 standard. It has two parts:

- The `sedutil-cli` command line utility which can set up and manage
  SED features.
- The pre-boot authorization image (PBA) which can be installed to an
  encrypted disk's shadow MBR area to allow entering a password to unlock
  the disk during boot.

## Warning
**Using this tool can make data on the drive inaccessible!**

## Fork
This is a fork of https://github.com/Drive-Trust-Alliance/sedutil and
https://github.com/CyrilVanErsche/sedutil. It merges some upstream PRs
and adds fixes.

## Copyright / original notice
![alt tag](https://avatars0.githubusercontent.com/u/13870012?v=3&s=200)

This software is Copyright 2014-2017 Bright Plaza Inc. <drivetrust@drivetrust.com>

This file is part of sedutil.

sedutil is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

sedutil is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with sedutil.  If not, see <http://www.gnu.org/licenses/>.
