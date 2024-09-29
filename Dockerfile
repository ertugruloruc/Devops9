# WordPress'in en son sürümünü kullanan resmi imajı temel alıyoruz
FROM wordpress:latest

# Çalışma dizinine geçiyoruz
WORKDIR /var/www/html

# MySQL'in gerekli paketlerini kuruyoruz
RUN apt-get update && apt-get install -y mariadb-server mariadb-client

# MySQL için varsayılan ayarları yapılandırıyoruz
RUN service mysql start && \
    mysql -e "CREATE DATABASE wordpress;" && \
    mysql -e "CREATE USER 'root'@'localhost' IDENTIFIED BY 'Mars.3188';" && \
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# WordPress için gerekli olan ortam değişkenleri
ENV WORDPRESS_DB_HOST=localhost:3306
ENV WORDPRESS_DB_USER=root
ENV WORDPRESS_DB_PASSWORD=Mars.3188
ENV WORDPRESS_DB_NAME=wordpress

# MySQL ve Apache'yi aynı anda çalıştırmak için bir başlangıç scripti oluşturuyoruz
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Gerekli portları açıyoruz
EXPOSE 80

# MySQL ve Apache'yi başlatıyoruz
CMD ["/start.sh"]
