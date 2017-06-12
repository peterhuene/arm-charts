#!/bin/bash
set -e

_check_env() {
	if [[ -z ${!1}  ]]; then
		>&2 echo "Error: $1 environment variable is required to be set."
		exit 1
	fi
}

_copy_content_files() {
	baseDir="$GHOST_SOURCE/content.orig"
	for dir in "$baseDir"/*/ "$baseDir"/themes/*/; do
		targetDir="$GHOST_CONTENT/${dir#$baseDir/}"
		mkdir -p "$targetDir"
		if [ -z "$(ls -A "$targetDir")" ]; then
			tar -c --one-file-system -C "$dir" . | tar xC "$targetDir"
		fi
	done
}

if [[ "$*" =~ ghost.*start.* ]]; then
	export NODE_ENV=$GHOST_ENVIRONMENT

   	# allow the container to be started with `--user`; if not, drop to the node user
	if [[ "$(id -u)" == "0" ]]; then
		_check_env "GHOST_ENVIRONMENT"
		_check_env "GHOST_URL"
		_check_env "GHOST_DATABASE_TYPE"

		_copy_content_files

		configFile="$GHOST_CONTENT/config.$GHOST_ENVIRONMENT.json"
		if [[ ! -f "$configFile" ]]; then
			echo "Creating Ghost configuration file '$configFile'."
			cat <<EOS > $configFile
{
  "url": "$GHOST_URL",
  "pname": "localhost",
  "process": "local",
  "server": {
    "host": "0.0.0.0",
    "port": $GHOST_PORT
  },
  "database": {
    "client": "$GHOST_DATABASE_TYPE",
    "connection": {
      "filename": "$GHOST_CONTENT/data/ghost-$GHOST_ENVIRONMENT.db",
      "host": "$GHOST_DATABASE_HOST",
      "user": "$GHOST_DATABASE_USER",
      "password": "$GHOST_DATABASE_PASSWORD",
      "database": "ghost_$GHOST_ENVIRONMENT"
    }
  },
  "mail": {
    "transport": "SMTP",
    "options": {
      "host": "$GHOST_SMTP_HOST",
      "port": "$GHOST_SMTP_PORT",
      "service": "$GHOST_SMTP_SERVICE",
      "auth": {
        "user": "$GHOST_SMTP_USER",
        "pass": "$GHOST_SMTP_PASSWORD"
      }
    }
  }
}
EOS
		fi

		# start the server to check database is up-to-date
		echo "Starting Ghost as root to ensure database is up-to-date."
		ghost start

		# stop the server before dropping to node user
		echo "Stopping Ghost and switching to non-root user."
		ghost stop

		chown node:node -R "$GHOST_CONTENT"
		exec su-exec node "$BASH_SOURCE" "$@"
        fi

	# shift out "ghost start"
	shift
	shift

	# directly run ghost (ghost start is asynchronous)
	echo "Starting Ghost as non-root user."
	exec ghost run $*
fi

exec "$@"
