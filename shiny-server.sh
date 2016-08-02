#!/bin/sh

# Make sure the directory for individual app logs exists
mkdir -p Desktop/var/log/shiny-server
chown shiny.shiny Desktop/var/log/shiny-server

exec shiny-server >> Desktop/var/log/shiny-server.log 2>&1
