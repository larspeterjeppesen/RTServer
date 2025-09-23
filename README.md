# RTServer
Simple server to make some rpg data available for lookups for my rogue trader rpg group.



# TODO

## Devops
1. the caddy command `sudo caddy reverse-proxy --from rtdata.dk --to :8080` has issues that need to be resolved.
  - It is using sudo to listen to ports 80 and 443, but can be configured in a safer way.
  - `www.rtdata.dk` is also a domain name, but is not being redirected currently.
  - This needs to be configured using a Caddyfile and run as a background service instead
  - Resource: https://caddyserver.com/docs/running
1. Setup service to run caddy and webserver on reboot/crash
  - Create dedicated user to run service

## Development
1. Display all talents on the website
  - Raw text to start with
  - Write a python script to format the raw string of talents (IN PROGRESS):
    - Break up prerequisite lines properly
      - Come up with regexp pattern (DONE)
      - Write logic to match and break the lines
    - Proper capitalization (DONE)
    - Correct newlines (DONE)
  - Write a python script to format it to html with headers and id's to allow fragment identification
    - Write luminen charge exception
