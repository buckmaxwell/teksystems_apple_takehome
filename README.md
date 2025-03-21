# TEKsystems / Apple Take Home Assignment

https://github.com/user-attachments/assets/e27a782b-ce04-4a49-be89-14d3d675bfb1

This is a Ruby on Rails application running inside Docker for local development. Since this is a simple project I chose to serve JavaScript from rails, though separating into a SPA could have some benefit at some point. Tests run on PRs and merges to the master branch. There is an integration test runner that runs on a schedule and can also be run manually. I chose to add postgres as an available database, initially planning to store information about requests made. Since this wasn't strictly part of the assignment I elected not to add those models, but set things up so that their addition would be easy.

## Prerequisites
- [Docker](https://www.docker.com/get-started) 
- Docker Compose (should be included with newer versions of Docker)

## Setup & Running

1. **Clone the Repository**  
   ```sh
   git clone git@github.com:buckmaxwell/teksystems_apple_takehome.git
   cd teksystems_apple_takehome
   ```

2. **Start the Services**  
   ```sh
   docker compose up -d
   ```

3. **Setup the Database**  
   ```sh
   docker compose run --rm web rails db:create db:migrate
   ```

4. **Access the App**  
   Open [http://localhost:3000](http://localhost:3000) in your browser.

## Useful Commands

| Command | Description |
|---------|------------|
| `docker compose up -d` | Start the app |
| `docker compose down` | Stop the app |
| `docker compose logs -f web` | View logs |
| `docker compose run --rm web rails c` | Open Rails console |
| `docker compose run --rm web bash` | Open a shell inside the container |

## Cleanup
To stop and remove containers:
```sh
docker compose down -v
```

## Troubleshooting
Check logs:
```sh
docker compose logs -f web
```
Reset the database:
```sh
docker compose run --rm web rails db:drop db:create db:migrate
```
