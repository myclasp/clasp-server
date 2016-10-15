# Snapp Server

## Installing and running for the first time: 

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

7. Run `docker-compose down` to shut down any containers

8. (Optionally, you can add dummy data:
  
  `docker-compose run clasp rake snapp:dummy`


## Running the application

### On Linux:

To start the app: `docker-compose up`

Then open in the browser with port 8000 e.g. `http://localhost:8000`

When you are done, hit `CTRL+C` and `docker-compose down`

### On osx:

To start the app: `docker-compose up`

Then check the ip: `docker-machine ip`

Then open this ip in the browser with port 8000 e.g. `http://192.168.99.100:8000`

When you are done, hit `Control+C` and `docker-compose down`

If you get:  ERROR: Couldn't connect to Docker daemon - you might need to run `docker-machine start default`.

`eval "$(docker-machine env default)"`


### Running tests

Run: `docker-compose clasp rake test`


## API Specification

POST /v1/users

  `{"user":{"email":"test@test.com", "password":"passwurd", "password_confirmation":"passwurd"}}`

Response:

  `{"success":true,"email":"test@test.com","id":"70b74dacfa"}`

  or
  
  `{"success":false,"errors":{"password_confirmation":["doesn't match Password"]}}`

POST /v1/auth_user

  `{ "email": "test@test.com", "password": "passwurd" }`

Response:

  `{"success":true,"email":"test@test.com","id":"70b74dacfa"}`

  or 

  `{"success":false,"errors":["Invalid Username/Password"]}`

POST /v1/users/[user_id]/moments
```
  { "moments":[
    {"identifier":1, "timestamp":2016-09-27 12:09:28 +0000, "state":0, "latitude":12.0, "longitude":-12.0}
  ]}
```
Response: 

  `{"success":true,"passed":[1],"failed":[],"errors":{}}`

GET /v1/users/[user_id]/moments?from=100000&to=1000000

- Optional `from` & `to` params can be used to specify a time range. These should be in unix timestamp.

Response:

```
  { success:true, "moments":[
    {"identifier":1, "timestamp":2016-09-27 12:09:28 +0000, "state":0, "latitude":12.0, "longitude":-12.0}
  ]}
```