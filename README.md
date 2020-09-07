# WRIR Dpcker Stack

This is the attempt to migrate WRIR backend services to containers for easier deployment and maintence. Also because we need to migrate in order to repair our servers.

Please contact Zachary Klosko (@Zack on Slack) for access or additional information

## Statuses

- stream-recorder: *working*
  - Recorder switches on it's own but still throws up a lot of errors
  - `whatson4.sh` and `getsched17.sh` appear to work, rest questionable
- webdav and json: *in testing*
  - Considering a switch to NGINX for hosting these two; haven't made much progress
  - Potential to host both directly from Synologies?
- ssh: *yet to start testing*
  - Idea: pass users/hashed passwords in via a script, try not to delete container
- icecast: *yet to start testing*
  - Idea: pass enviornment variables via docker-compose, likely doesn't need much tweaking