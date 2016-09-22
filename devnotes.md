# Clasp Devnotes

## Adding gems

Add gems to Gemfile as you would normally, don't run `bundle install`, this is done during the docker build process, ie: 

`docker-compose build` 

## Running commands via docker 

### Example: Generate a controller

`docker-compose run clasp rails g controller Pages home`

`docker-compose run clasp rails g model Moment state:string timestamp:timestamp latitude:float longitude:float`

`docker-compose run clasp rake db:migrate`

After generating files this way I had to change owner: `sudo chown -R digitalwestie:digitalwestie ./` to give permission to edit files.


## Project creation

Project created mostly by following: https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

Started by changing rails 4 to 5 in creating the project:

```
docker run -it --rm --user "$(id -u):$(id -g)" \
  -v "$PWD":/usr/src/app -w /usr/src/app rails:5 rails new --skip-bundle clasp
```

Then removed references to sidekiq / resq which we don't need.


## Sending Requests

Get user id:

curl -X POST -H "Content-Type: application/json" -d "{\"email\":\"giannichan@gmail.com\",\"password\":\"password\"}" http://localhost:8000/auth_user

Create moments

curl -X POST -H "Content-Type: application/json" -d "{\"user_id\":\"c893dda4ae\", \"moments\":[{\"identifier\":1,\"timestamp\":\"2016-09-22 18:22:19 +0100\",\"state\":0,\"latitude\":12.0,\"longitude\":-12.0}]}" http://localhost:8000/moments


