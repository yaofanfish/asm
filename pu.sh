#!/bin/sh
git add .
git commit -m "commit"
GIT_SSH_COMMAND='ssh -i /home/ff3/.ssh/github' git push origin main
