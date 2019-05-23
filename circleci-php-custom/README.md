## circleci-php-custom

CircleCI PHP build image w/ additional extensions
* PHP Modules
    * `iconv`
    * `gd`
    * `zip`
    * `pdo_mysql`
    * `pdo_sqlite`
    * `mcrypt`
* Libraries
    * `libmcrypt-dev`
    * `libsqlite3-dev`
    * `libfreetype6-dev`
    * `libjpeg62-turbo-dev`
    * `libpng-dev`
    * `zlib1g-dev `


### Usage Example

Use it in a CircleCI `.circleci/config.yml` definition just like you would use the stock image.

Example `.circleci/config.yml`:
```
version: 2
jobs:
  build:
    docker:
      - image: wernerw/circleci-php-custom
        environment:
          DB_CONNECTION: mysql
          DB_DATABASE: foo
          DB_USERNAME: fooser
          DB_PASSWORD: barbazquxquux
          CACHE_DRIVER: file
...

```