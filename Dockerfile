FROM mariadb:10.9.2-jammy

VOLUME /backups

RUN apt-get update -y && apt-get install cron -y && rm -rf /var/lib/apt/lists/*

COPY cronjob /etc/cron.d/cronjob

RUN chmod 0644 /etc/cron.d/cronjob && crontab /etc/cron.d/cronjob
RUN touch /var/log/cron.log

COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

COPY cron-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/cron-entrypoint.sh
RUN sh -c "cat /usr/local/bin/docker-entrypoint.sh >> /usr/local/bin/cron-entrypoint.sh"
RUN touch /usr/environment && chmod 777 /usr/environment

COPY maybe-import.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/maybe-import.sh

ENTRYPOINT ["cron-entrypoint.sh"]
CMD ["mariadbd"]
