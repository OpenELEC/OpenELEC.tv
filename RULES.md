#### Table of Contents

- [Package Version Bumps](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#package-version-bumps)
  - [OpenELEC Testing Window](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#openelec-testing-window)
  - [OpenELEC Release Window](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#openelec-release-window)
  - [Major Packages](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#major-packages)
  - [Minor Packages](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#minor-packages)
- [Fixes](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#fixes)
- [Reverts](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#reverts)
- [Trust](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#trust)
- [Changes to RULES.md](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#changes-to-mastermd)

## Package Version Bumps

This document pertains to the entire OpenELEC tree and all of it's branches.

#### OpenELEC Testing Window

Anything listed in the [Major Packages](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#major-packages) section **MUST** be submitted as a PR and reviewed.

Anything listed in the [Major Packages](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#major-packages) section will **NOT** be bumped unless there is unanimous support for it.

Anything listed in the [Minor Packages](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#minor-packages) section may be bumped

#### OpenELEC Release Window

Once an OpenELEC release has entered beta anything in the [Major Packages](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#major-packages) section will **NOT** be bumped with the exception of Kodi as it progresses to it's final release.

Once an OpenELEC release has entered beta anything in the [Minor Packages](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#minor-packages) section may be bumped **ONLY** if it fixes an outstanding issue.

#### Major Packages

- connman
- curl
- ffmpeg
- gcc
- glibc
- kodi
- linux
- mesa
- python
- systemd
- xf86-video-nvidia
- xorg-server

#### Minor Packages

Anything not listed in the [Major Packages](https://github.com/OpenELEC/OpenELEC.tv/blob/master/RULES.md#major-packages) section

## Fixes

Any fixes to outstanding issues must be submitted as a PR **and** be tested.

## Reverts

Any reverts must be submitted as a PR **and** provide information about why the revert needs to occur.

## Trust

These master are of course only practical if we can trust each other to use them accordingly.

If these master are broken, trust is broken.

## Changes to RULES.md

Any changes being made to this document must be submitted as a PR and reviewed by the current OpenELEC Team.
