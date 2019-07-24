#!/bin/sh

set -e

bundle install
rails db:drop db:create db:migrate db:seed
rails s