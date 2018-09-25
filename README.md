# Docker and You

This repo is focused on showing you how to setup a basic Rails application and configure Docker on top of it.

## Setup

To get started, you'll need to have Rails installed locally on your machine. If you don't have Rails, you can download it by running `bundle install rails` in your terminal.

To get started with this particular project, you can run the following commands to get started:

1. `bundle`
2. `rake db:create; rake db:migrate; rake db:seed`
3. `rails s`

Once you start your server, head over to `localhost:3000/api/v1/users` to see if anything populates from running your seed file. Use `control + c` to stop the server. 

_NOTE: This is not typically part of the workflow; this goal of this 'Setup' exercise was simply to let you see what the server/endpoints look like when running locally._

## Download Docker

You can find an easy way to download Docker right [here](https://docs.docker.com/docker-for-mac/install/)

Once you are all set up, head over to your terminal and type in `docker` to see if Docker was installed correctly. You should see a large menu populate.

## Create a Dockerfile

The Dockerfile is necessary to build an image. This file lets Docker know what dependencies the project needs - the image will have all of those dependencies.

Touch a new file at the root of the project directory called `Dockerfile` (no extension).

The contents of the file should be:

```
FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
```

## Create a docker-compose.yml file 

This file is also necessary! It's job is to describe the services of you database and web app, how to get the Docker image of each one, and the configuration needed to get the web app and database app to talk to each other. 

```
version: '3'
services:
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/myapp
    ports:
      - "3000:3000"
    depends_on:
      - db
 ```
 
## Build a container 

Run `docker-compose up` in your terminal. Be prepared to wait for a few minutes... 

## Set up your database for the container

In another tab of your terminal, run:

```
docker-compose run web rake db:create
docker-compose run web rake db:migrate
docker-compose run web rake db:seed
```

## Visit app in browser

Go to `http://localhost:3000/api/v1/users` - you should see the same thing you saw when running locally!

## Important Docker Commands

There are some commands that you'll need to reuse over and over again. Some of the most important ones are the following:

1. `docker-compose build` (builds an image)
2. `docker-compose up` (builds a container - if you _don't_ run `build`, this command will run both for you!)
3. `docker-compose down` (stops the container)
4. `docker images` (lists the running images)
5. `docker ps` (list the running containers)


## Clean up after yourself

You'll also need to make sure you are cleaning up after yourself when playing around with images and containers. If you don't you may see some unwanted side effects and your code being stale. It's a good habit to run these commands if you forcefully quit your docker containers.  

1. `docker rmi $(docker images --filter "dangling=true" -q --no-trunc)`
2. `docker rm $(docker ps -qa --no-trunc --filter "status=exited")`
