# Clasp Server

First time running: 

1. Install docker and docker-compose

2. Setup environment configs:

  * `.clasp.env` based on example `.example.env`
  * `docker-compose.yml` based on example `docker-compose.example.yml`

3. Create volume `docker volume create --name clasp-postgres`

4. Allow gems to update `rm Gemfile.lock` 

5. Init containers for first time `docker-compose up` (this should error, CTRL+C once it has stopped logging)

5. Setup db:

  ```
  docker-compose run --user "$(id -u):$(id -g)" clasp rake db:reset
  docker-compose run --user "$(id -u):$(id -g)" clasp rake db:migrate
  ```

6. Run `docker-compose up -d` and check it on `http://localhost:8000` (`-d` means detached)

# Running the app on osx:

To start the app: `docker-compose up`

Then check the ip: `docker-machine ip`

Then open this ip in the browser with port 8000 e.g. `http://192.168.99.100:8000`

When you are done, hit `Control+C` and `docker-compose down`

If you get:  ERROR: Couldn't connect to Docker daemon - you might need to run `docker-machine start default`.

`eval "$(docker-machine env default)"`