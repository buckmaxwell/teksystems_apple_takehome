# TEKsystems / Apple Take Home Assignment


This is a Ruby on Rails application running inside Docker for local development.

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
