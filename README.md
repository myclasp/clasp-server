# Clasp Server

First time running: 

1. Install docker and docker-compose

2. Setup environment config in `.clasp.env`, see `.example.env`

3. Create volume `docker volume create --name clasp-postgres`

4. Init containers for first time `docker-compose up` (this should error, CTRL+C once it has stopped logging)

5. Setup db:

```
  docker-compose run --user "$(id -u):$(id -g)" clasp rake db:reset
  docker-compose run --user "$(id -u):$(id -g)" clasp rake db:migrate
```
6. Run `docker-compose up` and check it on `http://localhost:8000`