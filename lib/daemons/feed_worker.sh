#!/usr/bin/env bash
USER=vagrant
APP_PATH=/vagrant
PATH=/home/$USER/.rbenv/bin:/home/$USER/.rbenv/shims:$PATH
RAILS_ENV=development

cd $APP_PATH
RAILS_ENV=$RAILS_ENV lib/daemons/feed_worker_ctl $1
