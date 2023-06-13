# docker-rails

Git clone the repository and remove the .git folder to begin. 

Rename the default_env file to .env and modify values.

By using the PGHOST, PGUSER, and PGPASSWORD environment variables they do not need to be set in the Rails database configuration file.

In production the password can be configured in a separate file for security.
https://www.postgresql.org/docs/current/libpq-pgpass.html

`git init`

`docker-compose build`

`docker compose run --no-deps --entrypoint /bin/sh --rm rails` to enter console for the rails app container.

Do the following from within the docker container.
`bundle install`

Use the rails new command to create the application. Customize to suit needs, ie. testing framework.

`rails new my_app_name -d postgresql --css tailwind`

Rails will put the files in a folder named my_app_name. 
`mv my_app_name/* . && rm -Rf my_app_name` to move the files into the current directory

Now exit the container.
Before starting the Docker compose stack, check the following:

Edit rails/Procfile.dev to bind the correct address:
`web: bin/rails server -p 3000 -b '0.0.0.0'`

To configure Redis for production edit config/cable.yml

```
production:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: app_production
```

See this guide if you want to add another Redis server to act as a cache server.
https://guides.rubyonrails.org/caching_with_rails.html#activesupport-cache-rediscachestore

Edit rails/Gemfile:
Uncomment Redis.
Remove "webdrivers" as they will be separate containers.

If you want to use web-console in docker make the following changes in `config/environments/development.rb`

```
require 'socket'
require 'ipaddr'

Rails.application.configure do
	config.web_console.whitelisted_ips = Socket.ip_address_list.reduce([]) do |res, addrinfo|
	  addrinfo.ipv4? ? res << IPAddr.new(addrinfo.ip_address).mask(24) : res
	end
...
```
`docker compose run --no-deps --entrypoint 'bundle install' --rm rails

`docker compose up -d`

We should now be ready to go.

