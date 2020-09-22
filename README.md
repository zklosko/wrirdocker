# WRIR Dpcker Stack

This is the attempt to migrate WRIR backend services to containers for easier deployment and maintence. Also because we need to migrate in order to repair our servers.

Please contact Zachary Klosko (@Zack on Slack) for access or additional information

## TODOs

- [x] Obtain SSL certificates for webdav, in `server.crt` and `server.key` files
- [x] Start working on networking between the containers and the outside network/internet
- [] Pull password file for use with ssh or put together a plan to distribute new passwords to users

## Updates

Replacing Bandito:

- icecast: *ready for deployment*
  - `docker run -d --publish 8000:8000 -e ICECAST_SOURCE_PASSWORD=wwr4trou -e ICECAST_ADMIN_PASSWORD=wwr4trou -e ICECAST_RELAY_PASSWORD=wwr4trou -e ICECAST_ADMIN_USERNAME=admin -e ICECAST_ADMIN_EMAIL=operations@wrir.org -e ICECAST_LOCATION=RVA -e ICECAST_HOSTNAME=bandito -e ICECAST_MAX_CLIENTS=50 -e ICECAST_MAX_SOURCES=2 --name icecast --restart=always infiniteproject/icecast`
- stream-recorder: *ready for deployment?*
  - Now based off Debian 9 (Stretch-slim)
  - `docker run -d -v "/wrirdocker/stream-recorder/scripts:/scripts" --name stream-recorder --restart=always recorder`
  - `docker run -d -v "/Users/zacharyklosko/Documents/GitHub/wrirdocker/stream-recorder/scripts:/scripts" --name stream-recorder recdeb`
  
Replacing Rostov:

- json: *in testing*
  - Using httpd
  - HTTP 401 Error page created
  - Cgi scripts appear to be executing correctly
  - Still need to enable hourly updates of the livesound archive
    - Make new container for CRON scripts?
  - `docker run -d -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/htdocs:/usr/local/apache2/htdocs -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/cgi-bin:/usr/local/apache2/cgi-bin -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/httpd.conf:/usr/local/apache2/conf/httpd.conf -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/stream-recorder/scripts/publish:/usr/local/apache2/htdocs/shows --publish 80:80 --restart=always --name files.wrir.org httpd`
    - Still need to mount Y and Z drives, and mount location for logs

Replacing Blackhand:

- webdav: *in testing*
  - Using Twizzel's fix of Bytemark's webdav image
  - Successfully accepts user.passwd file from Blackhand!
  - Using autogen self signed SSL cert
  - Doesn't run correctly on on-prem PC
  - `docker run -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/webdav/mounts:/var/lib/dav/data -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/webdav/user.passwd:/user.passwd -e AUTH_TYPE=Basic --publish 443:443 -e SSL_CERT=selfsigned -d --restart=always --name webdav twizzel/webdav`
- ssh: *not working*
  - Idea: pass users/hashed passwords in via a script, try not to delete container
  - `docker run -d --publish 2222:22 -v "/Users/zacharyklosko/Documents/GitHub/wrirdocker/sshd/entrypoint.d:/etc/entrypoint.d" -e SSH_ENABLE_PASSWORD_AUTH=true --name ssh panubo/sshd`
  - `docker run -ti --publish 2222:22 \
  -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/sshd/keys/:/etc/ssh/keys \
  -e SSH_USERS=user1:1012:1112,test:1013:1113 \
  -e SSH_ENABLE_PASSWORD_AUTH=true \
  -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/sshd/entrypoint.d/:/etc/entrypoint.d/ \
  panubo/sshd`