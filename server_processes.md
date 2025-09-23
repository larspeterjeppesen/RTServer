# Webserver
### Build server (if updated)
cargo build
### Copy service config to systemd folder (if updated)
cp webserver.service /etc/systemd/system/
### Reload systemd to recognize new service
sudo systemctl daemon-reload (only necessary first time the service is moved in the above step) 
### Enable and start service
sudo systemctl enable --now webserver.service
### Verify service is running
system status webserver.service
curl 127.0.0.1:8080

systemctl guide: https://last9.io/blog/systemctl-guide/#how-can-you-run-your-scripts-as-system-services

# Caddy
sudo caddy run
## If port 80 is already bound, it is probably caddy already running a service. To see running services:
## `systemctl --type=service --state=running`
## To close a running service:
## `sudo systemctl stop service_name.service`


