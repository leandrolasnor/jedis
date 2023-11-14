#!/usr/bin/env zsh
set -e

git pull
# Remove a potentially pre-existing server.pid for Rails.
rm -f /api/tmp/pids/server.pid
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"