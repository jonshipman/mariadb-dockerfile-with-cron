# mariadb-dockerfile-with-cron
Creates a docker image with an integrated cron. Why this instead of a separate service? This way each client is responsible for their own backups. Saves to /backups and only keeps a rolling 7.
