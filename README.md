# WRIR Docker Stack

This is the attempt to migrate WRIR backend services to containers for easier deployment and maintence. Also because we need to migrate in order to repair our servers.

Please contact Zachary Klosko (@Zack on Slack) for access or additional information

## TODOs

- [] Pull password file for use with ssh or put together a plan to distribute new passwords to users
- [] Get SSHD to accept user/password creation script

## Updates

Replacing Bandito:

- icecast: *ready for deployment*
  - `docker run -d --publish 8000:8000 -e ICECAST_SOURCE_PASSWORD=wwr4trou -e ICECAST_ADMIN_PASSWORD=wwr4trou -e ICECAST_RELAY_PASSWORD=wwr4trou -e ICECAST_ADMIN_USERNAME=admin -e ICECAST_ADMIN_EMAIL=operations@wrir.org -e ICECAST_LOCATION=RVA -e ICECAST_HOSTNAME=bandito -e ICECAST_MAX_CLIENTS=50 -e ICECAST_MAX_SOURCES=2 --name icecast --restart=always infiniteproject/icecast`
- stream-recorder: *[almost] ready for deployment*
  - Now based off Debian 9 (Stretch-slim)
  - Because of Docker networking, can read stream from "files.wrir.org:8000" but not "localhost:8000"
  - On prem: `docker run -d -v "/wrirdocker/stream-recorder/scripts:/scripts" --name stream-recorder -v /wrirdocker/webdav/mounts/Y:/Y -v /wrirdocker/json/htdocs:/htdocs --restart=always recorder`
  - `docker run -d -v "/Users/zacharyklosko/Documents/GitHub/wrirdocker/stream-recorder/scripts:/scripts" --name stream-recorder recdeb`
  - `docker run -ti --rm -v /wrirdocker/webdav/mounts/Y:/Y recorder`

Replacing Rostov:

- json: *in testing*
  - Using httpd
  - `showlist9` works as intended
  - `livesound2` doesn't return all necessary information
  - On prem: `docker run -d -v /wrirdocker/json/htdocs:/usr/local/apache2/htdocs -v /wrirdocker/json/cgi-bin:/usr/local/apache2/cgi-bin -v /wrirdocker/json/httpd.conf:/usr/local/apache2/conf/httpd.conf -v /wrirdocker/stream-recorder/scripts/publish:/usr/local/apache2/htdocs/shows -v /wrirdocker/webdav/mounts/Y:/Y --publish 80:80 --restart=always --name files.wrir.org httpd`
  - Local: `docker run -d -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/htdocs:/usr/local/apache2/htdocs -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/cgi-bin:/usr/local/apache2/cgi-bin -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/httpd.conf:/usr/local/apache2/conf/httpd.conf -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/stream-recorder/scripts/publish:/usr/local/apache2/htdocs/shows -v /wrirdocker/webdav/mounts/Y:/Y --publish 80:80 --restart=always --name files.wrir.org httpd`
    - Still need to mount location for logs

Replacing Blackhand:

- ssh: *in testing*
  - Idea: pass users/hashed passwords in via a script, try not to delete container
    - Or pass in usernames, hashed passwords via. `setpasswd.sh`, which runs on container build
  - On prem: `docker run -d --publish 2222:22 -v /wrirdocker/sshd/keys/:/etc/ssh/keys -e SSH_ENABLE_PASSWORD_AUTH=true --name ssh --restart=always ssh`
  - Local: `docker run -ti --publish 2222:22 -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/sshd/keys/:/etc/ssh/keys -e SSH_USERS=user:1000:1000 -e SSH_ENABLE_PASSWORD_AUTH=true ssh`
- webdav: *not working*
  - Using Twizzel's fix of Bytemark's webdav image
  - Successfully accepts user.passwd file from Blackhand!
  - Using autogen self signed SSL cert
  - Doesn't run correctly on on-prem PC; maybe is scanning files?
    - chown: /var/lib/dav/data/Y/.Trash-1001/files/Rock.2/U.S. Girls - In a Poem Unlimited (4AD, 2018)/07 - L-Over.mp3: Permission denied
  - On prem: `docker run -v /wrirdocker/webdav/mounts:/var/lib/dav/data:Z -v /wrirdocker/webdav/user.passwd:/user.passwd -e AUTH_TYPE=Basic --publish 443:443 -e SSL_CERT=selfsigned -ti --rm --restart=always --name webdav twizzel/webdav`
  - Local: `docker run -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/webdav/mounts:/var/lib/dav/data -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/webdav/user.passwd:/user.passwd -e AUTH_TYPE=Basic --publish 443:443 -e SSL_CERT=selfsigned -d --restart=always --name webdav twizzel/webdav`