#!/bin/bash

rsync -cvr --exclude Brewfile --exclude .git --exclude '*.sh' --exclude '*~' "$(dirname $0)" "${1:-$HOME}"
