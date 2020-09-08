# WRIR Dpcker Stack

This is the attempt to migrate WRIR backend services to containers for easier deployment and maintence. Also because we need to migrate in order to repair our servers.

Please contact Zachary Klosko (@Zack on Slack) for access or additional information

## Statuses

- stream-recorder: *working*
  - Recorder switches on it's own but still throws up a lot of errors
  - `whatson4.sh` and `getsched17.sh` appear to work, rest questionable
- webdav: *in testing*
  - Using Bytemark's webdav image
  - Unencrypted webdav does work on a local machine, but creates `data` folder inside bind directory; serves `data` folder instead of bind directory
- json: *yet to start testing*
  - Using httpd
  - Potential to host both directly from Synologies?
- ssh: *yet to start testing*
  - Idea: pass users/hashed passwords in via a script, try not to delete container
- icecast: *yet to start testing*
  - Idea: pass enviornment variables via docker-compose, likely doesn't need much tweaking