# Dockerized LEMP Environment

## What's this all about?
I like to try out new web (PHP) based apps. I also need to test existing apps on PHP 7.

This repo makes it really simple with docker-compose but is in no way production ready.
Configs are minimal and security hasn't been taken into consideration.

It's purely for dev / testing / fun purposes.

## How do I use it?
1. Extract your application to: `./app`
2. Run `docker-compose up`
3. Configure your application to use the following DB settings:
    * Host / Server: db
    * Username: root
    * Password: password
    * Database Name: application

### Help! I need to install PHP modules!?!
It's really simple. Edit: `./php/Dockerfile` and add the module name to a new
`RUN` instruction line. For example to add the `redis` PHP module:
```
RUN /usr/local/bin/docker-php-ext-install pdo pdo_mysql

RUN /usr/local/bin/docker-php-ext-install redis
```
> Why not just add it to the end of the existing RUN instruction?
> Docker caches the resulting changes from instructions in image layers.
> By adding a new RUN line we avoid downloading and building the existing
> modules again.

Some modules may require adding libraries or other packages. There's plenty of references
out there on doing this with the alpine Linux Docker containers.

## Example: Test PHP Server Monitor - https://www.phpservermonitor.org/
(The original reason I came up with this easy way of testing PHP apps)

* Download PHP Server Monitor from: http://www.phpservermonitor.org/download/
* Extract the contents to the `./app` folder
* Run `docker-compose up`
* Go to http://localhost:8080 to see the app (You should get the installation page)

# Example 2: Trying out Drupal 8 - https://www.drupal.com/
This is a bit more complex than the initial example. We need to install extra
PHP modules and OS libraries.

* Download the latest Drupal 8 (8.2.6 at time of writing) from:
  https://www.drupal.org/project/drupal/releases/8.2.6
* Extract the content to the `./app` folder
* Run `docker-compose up`
* Go to http://localhost:8080 and see the installation page.

At this point Drupal looks okay but if you click through the installation you.ll
get to the *Verify Requirements* page and have a nice big red error and warning due
to missing PHP modules.

## Add the `gd` PHP module
* Edit `./php/Dockerfile` and add: `RUN /usr/local/bin/docker-php-ext-install gd`
* Run `docker-compose build` and everything should now be great!

## Installing required libs
Okay, I lied in my last comment. The PHP module will fail to install due to
missing lib / dev packages. Let's install them:

* Edit `./php/Dockerfile` and amend the line:
  `RUN /usr/local/bin/docker-php-ext-install opcache gd` to:
  ```
  RUN apk add --update libpng-dev libjpeg-turbo-dev && \
      /usr/local/bin/docker-php-ext-install opcache gd
  ```
* Run `docker-compose build` again and I promise everything will (should) work out fine.
* Refresh your browser page and the error *should* be gone.

You can continue with the installation and have Drupal FUN!!

# Common tasks
To make things a little easier there's a Makefile that helps make various tasks a
bit quicker / safer:

* `make` restarts the docker-compose cluster
* `make up` builds and brings the cluster up
* 'make stop' you guessed it: stops the cluster
* `make interactive` brings the cluster up in the foreground
* `make clean` removes the contents of `./app` and `./db/data` - **DESTRUCTIVE**
* `make reset` stops the cluster, cleans ./app` and `./db/data` and performs a
  hard git reset on the repo to reset everything - **SUPER-DESTRUCTIVE**
