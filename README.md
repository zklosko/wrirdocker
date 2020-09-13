# WRIR Dpcker Stack

This is the attempt to migrate WRIR backend services to containers for easier deployment and maintence. Also because we need to migrate in order to repair our servers.

Please contact Zachary Klosko (@Zack on Slack) for access or additional information

## TODOs

- [] Obtain SSL certificates for webdav, in `server.crt` and `server.key` files
- [] Start working on networking between the containers and the outside network/internet
- [] Pull password file for use with ssh or put together a plan to distribute new passwords to users

## Updates

- icecast: *ready for deployment*
  - `docker run -d --publish 8000:8000 -e ICECAST_SOURCE_PASSWORD=wwr4trou -e ICECAST_ADMIN_PASSWORD=wwr4trou -e ICECAST_RELAY_PASSWORD=wwr4trou -e ICECAST_ADMIN_USERNAME=admin -e ICECAST_ADMIN_EMAIL=operations@wrir.org -e ICECAST_LOCATION=RVA -e ICECAST_HOSTNAME=bandito -e ICECAST_MAX_CLIENTS=50 -e ICECAST_MAX_SOURCES=2 --name icecast --restart=always infiniteproject/icecast`
- webdav: *working*
  - Using Twizzel's fix of Bytemark's webdav image
  - Successfully accepts user.passwd file from Blackhand!
  - Using autogen self signed SSL cert
  - Going to need to pass cifs folders as mount; cannot mount cifs inside container
  - Run: `docker run -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/webdav/mounts:/var/lib/dav/data -v /Users/zacharyklosko/Documents/GitHub/wrirdocker/webdav/user.passwd:/user.passwd -e AUTH_TYPE=Basic --publish 443:443 -e SSL_CERT=selfsigned -d twizzel/webdav`
- stream-recorder: *in testing*
  - Need to mount `htdocs/shows` directory from json container
  - `docker run -d -v "/Users/zacharyklosko/Documents/GitHub/wrirdocker/stream-recorder/scripts:/scripts" recorder`
- json: *in testing*
  - Using httpd
  - HTTP 401 Error page created
  - Cgi scripts appear to be executing correctly
  - Still need to enable hourly updates of the livesound archive
  - `docker run -it -v /wrirdocker/json/htdocs:/usr/local/apache2/htdocs -v /wrirdocker/json/cgi-bin:/usr/local/apache2/cgi-bin -v /wrirdocker/json/httpd.conf:/usr/local/apache2/conf/httpd.conf --publish 80:80 httpd`
    - Still need to mount Y and Z drives, and mount location for logs
- ssh: *yet to start testing*
  - Idea: pass users/hashed passwords in via a script, try not to delete container