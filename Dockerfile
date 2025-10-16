FROM php:8.4-apache

# Listen on 8080 for Cloud Run
# RUN sed -ri 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf \
#  && sed -ri 's!VirtualHost \*:80!VirtualHost \*:8080!g' /etc/apache2/sites-available/000-default.conf

# If you use a public/ web root, uncomment the next line
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html
COPY . .

EXPOSE 8080
CMD ["apache2-foreground"]
