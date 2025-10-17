FROM php:8.4-apache

# 1) Port 8080 for Cloud Run
RUN sed -ri 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf \
 && sed -ri 's!VirtualHost \*:80!VirtualHost \*:8080!g' /etc/apache2/sites-available/000-default.conf

# 2) Docroot /public
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# 3) Enable .htaccess + rewrite
RUN a2enmod rewrite \
 && printf '%s\n' \
   '<Directory /var/www/html/public>' \
   '    Options Indexes FollowSymLinks' \
   '    AllowOverride All' \
   '    Require all granted' \
   '</Directory>' \
   >> /etc/apache2/apache2.conf

RUN a2enmod headers

WORKDIR /var/www/html
COPY . .

EXPOSE 8080

# ---- choose PHP config by build arg ----
ARG APP_ENV=prod
# Will copy docker/php-prod.ini by default; for dev, pass --build-arg APP_ENV=dev
COPY docker/php-${APP_ENV}.ini /usr/local/etc/php/conf.d/99-app.ini

CMD ["apache2-foreground"]
