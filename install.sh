#!/bin/bash
set -e

# Load base utility functions like sunzi.mute() and sunzi.install()
source recipes/sunzi.sh

# This line is necessary for automated provisioning for Debian/Ubuntu.
# Remove if you're not on Debian/Ubuntu.
export DEBIAN_FRONTEND=noninteractive

export APP_WWW=/home/<%= @attributes.app_name %>/www/<%= @attributes.app_name %>/
export APP_USER=<%= @attributes.app_name %>

#sunzi.mute "apt-get -y update"
#sunzi.mute "apt-get -y upgrade"

source recipes/core.sh
source recipes/users.sh
source recipes/nginx.sh
source recipes/unicorn.sh
