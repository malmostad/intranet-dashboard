#!/usr/bin/env bash
# Set users rbenv environment and execute a ruby script with optional args

USER=vagrant
APP_PATH=/vagrant
PATH=/home/$USER/.rbenv/bin:/home/$USER/.rbenv/shims:$PATH
RAILS_ENV=development

cd $APP_PATH
RAILS_ENV=$RAILS_ENV $@
