#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -h $HOSTNAME -p $PORT -U $USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $DATABASE"` ]]; then
  echo "Database $DATABASE does not exist. Creating..."
  createdb -E UTF8 $DATABASE -l en_US.UTF-8 -T template0
  mix ecto.setup
  echo "Database $DATABASE created."
fi

exec mix phx.server
