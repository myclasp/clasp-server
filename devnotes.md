# Clasp Devnotes

## Running commands via docker 

### Example: Generate a controller

`docker-compose run clasp rails g controller Pages home`

`docker-compose run clasp rails g model Moment state:string timestamp:timestamp latitude:float longitude:float`

`docker-compose run clasp rake db:migrate`


## Project creation

Project created mostly by following: https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

Started by changing rails 4 to 5 in creating the project:

```
docker run -it --rm --user "$(id -u):$(id -g)" \
  -v "$PWD":/usr/src/app -w /usr/src/app rails:5 rails new --skip-bundle clasp
```

Then removed references to sidekiq / resq which we don't need.
