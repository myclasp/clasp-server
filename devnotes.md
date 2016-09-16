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

