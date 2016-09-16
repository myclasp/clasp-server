# Clasp Devnotes

Project created mostly by following: https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

Started by changing rails 4 to 5 in creating the project:

```
docker run -it --rm --user "$(id -u):$(id -g)" \
  -v "$PWD":/usr/src/app -w /usr/src/app rails:5 rails new --skip-bundle clasp
```

Then removed references to sidekiq / resq which we don't need.

In the docker-compose.yml file, we're referencing volumes that do not exist. We can create them by running:

`docker volume create --name clasp-postgres`


-------------------

First time running: 

1. Install docker and docker-compose

2. Setup environment in `.clasp.env`

3. Create volume `docker volume create --name clasp-postgres`

4. Init containers for first time `docker-compose up` (this should error, CTRL+C once it has stopped logging)

5. Setup db:

```
  docker-compose run --user "$(id -u):$(id -g)" clasp rake db:reset
  docker-compose run --user "$(id -u):$(id -g)" clasp rake db:migrate
```

