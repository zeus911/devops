#!/usr/bin/env bash

url=$1

WWW_DIR=/home/worker/data/www/awstats
HTML_DIR=$WWW_DIR/html

mkdir -p $HTML_DIR

$HOME/awstats/tools/awstats_buildstaticpages.pl -update -config=${url} -lang=cn -dir=$HTML_DIR -awstatsprog=$HOME/awstats/wwwroot/cgi-bin/awstats.pl
