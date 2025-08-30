# RTServer
Simple server to make some rpg data available for lookups for my rogue trader rpg group.



# TODO
1. the caddy command `sudo caddy reverse-proxy --from rtdata.dk --to :8080` has issues that need to be resolved.
  - It is using sudo to listen to ports 80 and 443, but can be configured in a safer way.
  - `www.rtdata.dk` is also a domain name, but is not being redirected currently.
  - This needs to be configured using a Caddyfile and run as a background service instead
  - Resource: https://caddyserver.com/docs/running
1. Display all talents on the website
1. Enable links to talents
  - Something like rtdata.dk/talents#Peer
1. Setup service to run caddy and webserver on reboot/crash
