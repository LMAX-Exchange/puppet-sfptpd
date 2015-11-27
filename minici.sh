#! /bin/sh
#
# ci.sh
# Copyright (C) 2015 Tim Hughes <thughes@thegoldfish.org>
#
# Distributed under terms of the MIT license.
#
# Simple test runner that watches fir changes and runs `rake spec`
# Can be run with Bundler:
#
#     bundle exec ./ci.sh

type inotifywait || echo "inotify-tools is not installed"

while true
do 
    inotifywait -q -q -r -e 'close_write' \
         --exclude '^\..*\.sw[px]*$|4913|~$|.git/.*\.lock$|.*i\.log$|spec/fixtures' .
    rake spec
done