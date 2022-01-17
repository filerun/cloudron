FROM cloudron/base:3.2.0@sha256:ba1d566164a67c266782545ea9809dc611c4152e27686fd14060332dd88263ea

COPY ./filerun /app/pkg

RUN apt-get update && apt-get install -y \
    ffmpeg  \
    libreoffice  \
    ghostscript  \
    libmagickcore-6.q16-6-extra  \
    libgs-dev  \
    php-imagick &&  \
    rm -r /var/cache/apt /var/lib/apt/lists && \
#
    a2disconf other-vhosts-access-log && \
    echo "Listen 8000" > /etc/apache2/ports.conf && \
    a2enmod rewrite env && \
    rm /etc/apache2/sites-enabled/* && \
    sed -e 's,^ErrorLog.*,ErrorLog "|/bin/cat",' -i /etc/apache2/apache2.conf && \
# allow imagemagik to generate PDF thumbnails
    sudo sed -i -e 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml && \
#
    mkdir /tmp/ioncube && \
    curl http://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz | tar zxvf - -C /tmp/ioncube && \
    cp /tmp/ioncube/ioncube/ioncube_loader_lin_7.4.so /usr/lib/php/20190902/ && \
    rm -rf /tmp/ioncube && \
    echo "zend_extension=/usr/lib/php/20190902/ioncube_loader_lin_7.4.so" > /etc/php/7.4/apache2/conf.d/00-ioncube.ini && \
    echo "zend_extension=/usr/lib/php/20190902/ioncube_loader_lin_7.4.so" > /etc/php/7.4/cli/conf.d/00-ioncube.ini && \
#
    cp /app/pkg/filerun-optimization.ini /etc/php/7.4/apache2/conf.d/ && \
    cp /app/pkg/filerun-optimization.ini /etc/php/7.4/cli/conf.d/ && \
    mv /app/pkg/filerun.conf /etc/apache2/sites-enabled/filerun.conf && \
    mv /app/pkg/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf && \
#
    mkdir -p /app/data/html && \
    mkdir -p /app/data/logs && \
    mkdir -p /app/data/php_sessions && \
    mkdir -p /app/data/user-files && \
    chmod +x /app/pkg/entrypoint.sh

CMD ["/app/pkg/entrypoint.sh"]