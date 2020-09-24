#!/usr/bin/env bash

set -e

adduser -D --no-create-home zackaklosko

echo 'zackaklosko:BxHi2wZxBn>D8K;Q' | chpasswd

# Or if you do pre-hash the password remove the line above and uncomment the line below.
# echo "user1:passwordhashgoeshere" | chpasswd --encrypted