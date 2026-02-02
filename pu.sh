#!/bin/bash
git add .
com=$(git commit -m "commit")
if [[ com != *"nothing to commit, working tree clean"* ]]; then # needs bash
	GIT_SSH_COMMAND='ssh -i /home/ff3/.ssh/github' git push origin main
else
	echo "nothing to commit, so not pushing"
fi
