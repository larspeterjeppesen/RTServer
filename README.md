# RTServer
Simple server to make some rpg data available for lookups for my rogue trader rpg group.



# TODO

## Devops

### CI/CD Script
1. Set up new EC2 instance as test machine (DONE)
2. Write script to deploy an run tests of updated code on test machine (DONE)
3. Write script to deploy on live machine (DONE)
4. Add update to caddyfile as part of live machine deployment
5. make service and caddy deployment part of the test machine
6. fix space issue on live server, not all updates go through


## Development
1. Display all talents on the website (DONE)
  - Raw text to start with
  - Write a python script to format the raw string of talents (DONE):
    - Break up prerequisite lines properly
      - Come up with regexp pattern (DONE)
      - Write logic to match and break the lines (DONE)
    - Proper capitalization (DONE)
    - Correct newlines (DONE)
    - Write luminen charge exception (DONE)
  - Write a rust script to format it to html with headers and id's to allow fragment identification (IN PROGRESS)

