#!/bin/bash
# @author: David Lonjon
# Created:   2014/10/10
# Modified:   2014/10/10

CURRENT_DIR=`dirname $0`
SETTINGS_DIR_PATH="$CURRENT_DIR/settings"
TEMPLATES_DIR_PATH="$CURRENT_DIR/templates"

# Creating the settings.yml file
if [ ! -f $SETTINGS_DIR_PATH/settings.yml ]; then
    cp $TEMPLATES_DIR_PATH/settings.yml.template $SETTINGS_DIR_PATH/settings.yml
else
    echo -e "\nThe $SETTINGS_DIR_PATH/settings.yml file already exists."
fi

# Creating the salt_settings.yml file
if [ ! -f $SETTINGS_DIR_PATH/salt_settings.yml ]; then
    cp $TEMPLATES_DIR_PATH/salt_settings.yml.template $SETTINGS_DIR_PATH/salt_settings.yml
else
    echo -e "\nThe $SETTINGS_DIR_PATH/settings_salt.yml file already exists."
fi

echo -e "\nThe settings files (settings.yml and salt_settings.yml) located in $SETTINGS_DIR_PATH/ have been created. Please edit them to suit your environment and run 'vagrant up'"

