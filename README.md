# WRIR Docker Stack

This is the attempt to migrate WRIR backend services to containers for easier deployment and maintence. Also because we need to migrate in order to repair our servers.

Please contact Zachary Klosko (@Zack on Slack) for access or additional information

## Instructions

1. Clone down this repo into the root directory of the filesystem `/`
2. Follow the instructions on docker.com to install Docker and Docker-Compose
3. Mount the network drives to `/wrirdocker/mounts/Y` and `/wrirdocker/mounts/Z` using [this TechRepublic article](https://www.techrepublic.com/article/how-to-permanently-mount-a-windows-share-on-linux/)
4. cd into the repo and run `docker-compose up -d`
5. After the containers are launched, run `htop` to monitor the system's process. The initial load on the processor should calm back down after 5-10 minutes.
6. ???
7. Profit... er, non-profit that is

## TODOs

- [ ] Pull password file for use with ssh or put together a plan to distribute new passwords to users
- [ ] Get SSHD to accept user/password creation script
- [x] Verify archiving abilities of stream-recorder

## Updates

Replacing Bandito:

- icecast: *ready for deployment*
  - `docker run -d --publish 8000:8000 -e ICECAST_SOURCE_PASSWORD=wwr4trou -e ICECAST_ADMIN_PASSWORD=wwr4trou -e ICECAST_RELAY_PASSWORD=wwr4trou -e ICECAST_ADMIN_USERNAME=admin -e ICECAST_ADMIN_EMAIL=operations@wrir.org -e ICECAST_LOCATION=RVA -e ICECAST_HOSTNAME=bandito -e ICECAST_MAX_CLIENTS=50 -e ICECAST_MAX_SOURCES=2 --name icecast --restart=always infiniteproject/icecast`
- stream-recorder: *ready for deployment*
  - Now based off Debian 9 (Stretch-slim)
  - Because of Docker networking, can read stream from "files.wrir.org:8000" but not "localhost:8000"
  - On prem: `docker run -d -v "/wrirdocker/stream-recorder/scripts:/scripts" --name stream-recorder -v /wrirdocker/webdav/mounts/Y:/Y -v /wrirdocker/json/htdocs:/htdocs -v /wrirdocker/webdav/mounts/Z:/Z --restart=always recorder`
  - Test: `docker run -v "/wrirdocker/stream-recorder/scripts:/scripts" -v /wrirdocker/json/htdocs:/htdocs --rm -ti recorder`

Replacing Rostov:

- json: *ready for deployment*
  - Using httpd
  - `showlist9`, `sl2-SpecialNeeds`, `liveBands` - `livesound2` work as intended
  - `heart` doesn't work over ssh tunnel
  - `get5` - `getTrack` doesn't work, even on the current server
  - On prem: `docker run -d -v /wrirdocker/json/htdocs:/usr/local/apache2/htdocs -v /wrirdocker/json/cgi-bin:/usr/local/apache2/cgi-bin -v /wrirdocker/json/httpd.conf:/usr/local/apache2/conf/httpd.conf -v /wrirdocker/stream-recorder/scripts/publish:/usr/local/apache2/htdocs/shows -v /wrirdocker/webdav/mounts/Y:/Y --publish 80:80 --restart=always --name files.wrir.org httpd`
  - Local: `docker run -d -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/htdocs:/usr/local/apache2/htdocs -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/cgi-bin:/usr/local/apache2/cgi-bin -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/httpd.conf:/usr/local/apache2/conf/httpd.conf -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/stream-recorder/scripts/publish:/usr/local/apache2/htdocs/shows --publish 80:80 httpd`
    - Still need to mount location for logs

Replacing Blackhand:

- webdav: *ready for deployment*
  - Using isyangban's fix of Bytemark's webdav image, needs manual build
  - Successfully accepts user.passwd file from Blackhand!
  - Using autogen self signed SSL cert
  - On prem: `docker run -v /wrirdocker/mounts:/var/lib/dav/data -v /wrirdocker/webdav/user.passwd:/user.passwd -e AUTH_TYPE=Basic --publish 443:443 -e SSL_CERT=selfsigned --name webdav --restart=always -d webdav`
  - Local: `docker run -v /Volumes/files.wrir.org:/var/lib/dav/data -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/webdav/user.passwd:/user.passwd -e AUTH_TYPE=Basic --publish 443:443 -e SSL_CERT=selfsigned -ti webdav`
- ssh: *not working*
  - Idea: pass users/hashed passwords in via a script, try not to delete container
    - Or pass in usernames, hashed passwords via. `setpasswd.sh`, which runs on container build
  - On prem: `docker run -d --publish 2222:22 -v /wrirdocker/sshd/keys/:/etc/ssh/keys -e SSH_ENABLE_PASSWORD_AUTH=true -e TCP_FORWARDING=true --name ssh --restart=always ssh`
  - Local: `docker run -ti --publish 2222:22 -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/sshd/keys/:/etc/ssh/keys -e SSH_USERS=user:1000:1000 -e SSH_ENABLE_PASSWORD_AUTH=true ssh`