#!/bin/bash

function main_menu {
  while true; do
    clear
    echo "===================="
    echo "ACME.SH Certificate"
    echo "===================="
    echo "1. Request single domain certificate using webroot"
    echo "2. Request single domain certificate using nginx"
    echo "3. Request single domain certificate using standalone (port 80)"
    echo "4. Request wildcard certificate using Cloudflare API"
    echo "5. Exit"
    read -p "Enter your choice [1-5]: " choice
    case $choice in
      1) request_single_domain_webroot ;;
      2) request_single_domain_nginx ;;
      3) request_single_domain_standalone ;;
      4) request_wildcard_cloudflare ;;
      5) exit 0 ;;
      *) echo -e "${RED}Invalid option. Please try again.${NC}" && sleep 1
    esac
  done
}

function request_single_domain_webroot {
  read -p "Enter your domain name: " domain
  read -p "Enter the path to your webroot directory: " webroot
  acme.sh --issue --webroot "$webroot" -d "$domain"
  install_certificate "$domain"
}

function request_single_domain_nginx {
  read -p "Enter your domain name: " domain
  read -p "Enter the path to your nginx configuration file: " nginx_conf
  acme.sh --issue --nginx "$nginx_conf" -d "$domain"
  install_certificate "$domain"
}

function request_single_domain_standalone {
  read -p "Enter your domain name: " domain
  acme.sh --issue --standalone -d "$domain" -k 4096 --httpport 80
  install_certificate "$domain"
}

function request_wildcard_cloudflare {
  read -p "Enter your Cloudflare email address: " cloudflare_email
  read -p "Enter your Cloudflare API key: " cloudflare_api_key
  read -p "Enter your domain name: " domain
  acme.sh --issue --dns dns_cf -d "*.$domain" --dns-dns_cf_email "$cloudflare_email" --dns-dns_cf_key "$cloudflare_api_key"
  install_certificate "*.$domain"
}

function install_certificate {
  domain="$1"
  acme.sh --install-cert -d "$domain" --key-file /etc/ssl/private/private.key --fullchain-file /etc/ssl/private/cert.crt
}

main_menu