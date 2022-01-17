#!/bin/bash
set -eux

# Install FileRun on first run
if [ ! -e /app/data/html/index.php ];  then
	echo "[Downloading latest FileRun version]"
  curl -o /tmp/filerun.zip -L 'https://filerun.com/download-latest-docker-cloudron'
	unzip -q /tmp/filerun.zip -d /app/data/html/
	cp /app/pkg/overwrite_install_settings.temp.php /app/data/html/system/data/temp/
	cp /app/pkg/.htaccess /app/data/html/
	rm -f /tmp/filerun.zip
	chown -R cloudron:cloudron /app/data
	echo "Open this server in your browser to complete the FileRun installation."
fi

export FR_DB_HOST=${CLOUDRON_MYSQL_HOST}
export FR_DB_NAME=${CLOUDRON_MYSQL_DATABASE}
export FR_DB_USER=${CLOUDRON_MYSQL_USERNAME}
export FR_DB_PASS=${CLOUDRON_MYSQL_PASSWORD}

chown -R www-data:www-data /app/data/logs /app/data/php_sessions /app/data/user-files /app/data/html/system/data /run /tmp
APACHE_CONFDIR="" source /etc/apache2/envvars
rm -f "${APACHE_PID_FILE}"

exec /usr/sbin/apache2 -DFOREGROUND