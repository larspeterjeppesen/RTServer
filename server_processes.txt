# Webserver
cargo run

# Caddy
sudo caddy reverse-proxy -from rtadat.dk --to :8080
## If port 80 is already bound, it is probably caddy already running a service. To see running services:
## `systemctl --type=service --state=running`
## To close a running service:
## `sudo systemctl stop service_name.service`


