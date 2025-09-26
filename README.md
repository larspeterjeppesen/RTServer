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

I'm pushing code that is breaking the website. I want to create a CI/CD workflow. I want to create it from scratch to get into the problem space naturally.


Current workflow:
1. write new code on work pc
1. push to github
1. ssh into server
1. pull code from github
1. rebuild server
1. restart systemctl service
1. manually check if commit works as intended

Two issues to address here:
1. automate steps beyond step 2.
2. insert test environment prior to modifying production (which starts when code is pulled from github onto the webserver)
I could run the test environment either on my work pc, or on the webserver itself. A third option is to have a second machine running these tests. I could actually just make another EC2 instance that does this. That is the most robust solution I think, as it will be an environment I can easily wipe/reset. The only thing about this is that I cannot run mirror the caddy setup. Caddy also should not have to be restarted anyway when rebuilding the webserver.

What should an environment reset look like?
I could do a clean install of everything. I could even deploy a new EC2 instance. But I don´t want that, that's not a good way to deploy updates to the production environment either. Or, in some cases it may be, but changing one line of code should not trigger something as pervasive as a complete system reset.
I could do different resets depending on the data I am changing.
I currently imagine the following types of changes:
1. Webserver code change
    1. cargo build
    2. sudo systemctl restart webserver.service
2. webserver service update
    1. mv webserver.service /etc/...
    2. sudo systemctl restart webserver.service
3. Caddy update
    1. not sure. Caddy is still not properly set up as a service.

I want to start by implementing automation for webserver code changes, as that is what I will be doing mostly, and also to simplify the implementation. 
after updating the environment, I want to run any tests that I have made.
Currently I just imagine a few tests (pseudo code):

Check that server is hosting the data it is supposed to:
  diff (curl localhost:8080) RTServer/data/RT_talents.txt
  assert($? == 0)

To seperate testing purpose more, I could add a test checking the status of webserver.service


Draft of CI/CD workflow:
1. write new code on work pc
1. Commit new code
1. run CI/CD trigger
1. CI/CD trigger is a script that:
  1. pushes my commit
  2. ssh into test machine
  3. pulls new code
  4. reset environment
    - Currently this includes deleting the systemd service and reinserting it.
  5. does a complete setup
  6. runs tests
  7. - if they fail, report it and shut down
     - if they succeed, ask for confirmation to repeat the behavior on the production machine







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
