#!/usr/bin/env bash
set -xeuo pipefail
/usr/bin/wait-for-tcp.sh db 5432
/usr/bin/wait-for-tcp.sh redis 6379
if [[ -f ./tmp/pids/server.pid ]]; then
	rm ./tmp/pids/server.pid
fi

if ! [[ -f .db-created ]] && [[ -f db/schema.rb ]]; then
	bin/rails db:drop db:create db:setup
	touch .db-created
elif ! [[ -f .db-created ]] && ! [[ -f db/schema.rb ]]; then
	bin/rails db:drop db:create db:migrate
	touch .db-created
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
