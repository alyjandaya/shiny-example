#!/bin/sh

# Make sure the directory for individual app logs exists
sudo mkdir -p /var/log/shiny-server
sudo chown -R shiny.shiny /var/log/shiny-server

exec shiny-server >> /var/log/shiny-server.log 2>&1

