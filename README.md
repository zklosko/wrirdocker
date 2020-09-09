# WRIR Dpcker Stack

This is the attempt to migrate WRIR backend services to containers for easier deployment and maintence. Also because we need to migrate in order to repair our servers.

Please contact Zachary Klosko (@Zack on Slack) for access or additional information

## TODOs

- [] Obtain SSL certificates for webdav and json containers, in `server.crt` and `server.key`files
- [] Start working on networking between the containers and the outside network/internet
- [] Pull password file for use with ssh or put together a plan to distribute new passwords to users

## Updates

- stream-recorder: *working*
  - Recorder switches on it's own but still throws up a lot of errors
  - `whatson4.sh` and `getsched17.sh` appear to work, rest questionable
  - `docker run -ti -v "/Users/zacharyklosko/Documents/GitHub/wrirdocker/stream-recorder/scripts:/scripts" recorder`
- webdav: *in testing*
  - Using Bytemark's webdav image
  - Unencrypted webdav does work on a local machine
  - Need to find way to pass SSL certificate to container
  - Going to need to pass cifs folders as mount; cannot mount cifs inside container
  - `docker run -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/webdav/mounts:/var/lib/dav/data -e AUTH_TYPE=Basic -e USERNAME=test -e PASSWORD=test --publish 80:80 -d bytemark/webdav
  directory`
- json: *in testing*
  - Using httpd
  - HTTP 401 Error page created
  - Cgi scripts appear to be executing correctly
  - `docker run -it -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/htdocs:/usr/local/apache2/htdocs -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/cgi-bin:/usr/local/apache2/cgi-bin -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/json/httpd.conf:/usr/local/apache2/conf/httpd.conf --publish 80:80 httpd`
    - Still need to mount Y and Z drives, and mount location for logs
- ssh: *yet to start testing*
  - Idea: pass users/hashed passwords in via a script, try not to delete container
- icecast: *yet to start testing*
  - Idea: pass enviornment variables via docker-compose, likely doesn't need much tweaking
  - Biggest obstical is figuring out how to network containers so that they appear on the station's network. Thinking of `macvlan`.
  - `docker run -d -p 8000:8000 -e ICECAST_SOURCE_PASSWORD=wwr4trou -e ICECAST_ADMIN_PASSWORD=wwr4trou -e ICECAST_RELAY_PASSWORD=wwr4trou -e ICECAST_ADMIN_USERNAME=admin -e ICECAST_ADMIN_EMAIL=operations@wrir.org -e ICECAST_LOCATION=RVA -e ICECAST_HOSTNAME=bandito -e ICECAST_MAX_CLIENTS=50 -e ICECAST_MAX_SOURCES=2 infiniteproject/icecast`