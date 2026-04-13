#!/bin/sh
set -eu

export HOME=/home/rails
export USER=rails
export LOGNAME=rails
export SHELL=/bin/bash

cd /rails
exec gosu rails /bin/bash -l
