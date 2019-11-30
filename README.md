# Unofficial bolt-cms docker images

Bolt is an open source Content Management Tool, which strives to be as simple and straightforward as possible. It is quick to set up, easy to configure, uses elegant templates, and above all: It’s a joy to use.

This repository contains (unofficial) Docker images, served with Apache and PHP.

## Supported tags

* `3.6`, `latest`
* `3.5`,
* `3.4`,
* `3.3`

## Usage

You can find example scripts in the `examples` directory.

### Using docker run

First, pull the image.

```sh
docker pull chibicitiberiu/bolt-cms:latest
```

Then run using the following command.

```sh
docker run -p 80:80 \
    --name my_bolt_site \
    -v config_dir:/var/www/html/app/config
    -v database_dir:/var/www/html/app/database
    -v files_dir:/var/www/html/public/files
    -v extensions_dir:/var/www/html/extensions
    -d -t chibicitiberiu/bolt-cms
```
This command will start a new container that contains Bolt CMS, and uses a SQLite database.
The configuration directory will be populated with the configuration (such as `contenttypes.yml`) on the first run.

You can use a different database system by creating a `config.yml` file that exists `config_dir:/var/www/html/app/config` volume. See the examples in the `examples` directory.


## Using docker-compose


```yml
version: '3.1'

services:
    bolt:
        image: chibicitiberiu/bolt-cms
        volumes:
            - config_dir:/var/www/html/app/config
            - database_dir:/var/www/html/app/database
            - files_dir:/var/www/html/public/files
            - extensions_dir:/var/www/html/extensions

```