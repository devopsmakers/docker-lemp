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
It's really simple. Edit: `./php/Dockerfile` and add the module name to the existing
`RUN` command line. For example to add the `redis` PHP module:
```
RUN /usr/local/bin/docker-php-ext-install pdo pdo_mysql redis
```

Some modules may require adding libraries or other packages. There's plenty of references
out there on doing this with the alpine Linux Docker containers.

## Example: Test PHP Server Monitor - https://www.phpservermonitor.org/
(The original reason I came up with this easy way of testing PHP apps)

* Download PHP Server Monitor from: http://www.phpservermonitor.org/download/
* Extract the contents to the `./app` folder
* Run `docker-compose up`
* Go to http://localhost:8080 to see the app (You should get the installation page)

That's it, you have persistent MySQL data in `./db/data`. You might need to take a little time
getting other apps to work but it shouldn't be too difficult.
