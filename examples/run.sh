#!/bin/bash

docker pull chibicitiberiu/bolt-cms:latest 

docker run -p 80:80 \
    --name my_bolt_site \
    -v config_dir:/var/www/html/app/config
    -v database_dir:/var/www/html/app/database
    -v files_dir:/var/www/html/public/files
    -v extensions_dir:/var/www/html/extensions
    -d -t chibicitiberiu/bolt-cms