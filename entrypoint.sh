#! /bin/bash
# Copyright 2019 Peter Williams <peter@newton.cx>
# Licensed under the MIT License.
#
# This is the "entrypoint" script for TeXLive-in-a-box. When the user runs
# "docker run tlaib:latest foo bar", we are invoked with $1=foo and $2=bar.
#
# The purpose of this script is to run the passed command under the UID/GID
# associated with a given path in the container. The idea is that if we're run
# by a user with one of their directories bind-mounted somewhere, we can
# figure out which UID and GID to adopt by looking at the ownership of that
# directory.
#
# This script is designed to run on Alpine Linux. The following packages
# must be installed:
#
#   bash
#   sudo
#
# And that's it at the moment!

# This setting controls the path that we look at. We hardcode it here but
# there's no reason you couldn't store it as an environment variable, pass it
# as an argument, etc.
refpath=/work

# Get the UID and GID!
uid=$(stat -c %u "$refpath")
gid=$(stat -c %g "$refpath")

# Get the name of a group with that GID. If one doesn't already exist, create
# one. (We take this approach so that the entrypoint can run successfully
# multiple times within the same container, if needed. Also, note that the
# system may come preloaded with a group with the given GID.)
gname=$(grep "^[^:]*:[^:]*:$gid:" /etc/group |cut -d: -f1)
if [ -z "$gname" ] ; then
    gname="grp$gid"
    addgroup -g "$gid" "$gname"
fi

# Same deal, for a user with the given UID and primary group GID.
uname=$(grep "^[^:]*:[^:]*:$uid:$gid:" /etc/passwd |cut -d: -f1)
if [ -z "$uname" ] ; then
    uname="u${uid}g${gid}"
    adduser -u "$uid" -G "$gname" -h "/home/$uname" -D "$uname"
fi

# Ready to rock. We use `sudo` because the inner-shell quoting semantics of
# `su` are a pain.
exec sudo -u "$uname" "$@"
