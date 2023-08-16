# Use the official PHP image as the base image
FROM php:8.2-fpm

# Set the working directory in the container
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    zip \
    unzip \
    bash

# Install PHP extensions required for Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the Laravel application files into the container
COPY . .

# Install Laravel dependencies using Composer
RUN composer install

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]

# Optional: You can add environment variables and additional configuration here
RUN composer update
RUN chown -R www-data:www-data storage
RUN chown -R www-data:www-data bootstrap/cache
RUN chmod -R 775 storage
RUN chmod -R 775 bootstrap/cache
