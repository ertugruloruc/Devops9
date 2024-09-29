#!/bin/bash

# MySQL sunucusunu başlatıyoruz
service mysql start

# Apache (WordPress) sunucusunu başlatıyoruz
apache2-foreground
