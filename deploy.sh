#!/bin/bash

# Exit with nonzero exit code if anything fails
set -e

# Borrowed from https://gist.github.com/kamranayub/ca7b6866ab43771d9da8#file-deploy-sh and https://gist.github.com/domenic/ec8b0fc8ab45f39403dd
echo "Running deployment script..."

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`
ORG_NAME="wearefine"
MANIFEST_FILE_NAME="./$ORG_NAME.github.io.manifest.txt"
REPOS_TO_COMPILE='fae fine-forever frob-core fryr maximus slim-gym'

mkdir _deploy
mkdir _git_src

# Clone a fresh copy of the current repo to _deploy (this will be used later)
git clone $REPO _deploy

cd _git_src

# Clone repos to compile
for repo_name in $REPOS_TO_COMPILE; do
  git clone -b master "https://github.com/$ORG_NAME/${repo_name}.git"

  # Enter cloned repo
  cd "$repo_name"

  # Search for manifest file
  if [ -e "$MANIFEST_FILE_NAME" ]; then
    # Copy relevant files specified in child repo, going line-by-line
    while read path_name; do
      # If it's a README, ignore.
      if [ "$path_name" == "README.md" ]; then
        cp "./$path_name" "../../_deploy/$repo_name/index.md"
      else
        cp -r "./$path_name" "../../_deploy/$repo_name/$path_name"
      fi
    done < "$MANIFEST_FILE_NAME"
  else
    echo "Manifest not found for $repo_name"
  fi

  # Return to _git_src directory
  cd ..
done

cd ../_deploy

git config user.name "Travis-CI"
git config user.email "travis-ci@$ORG_NAME.com"

# Commit the "changes", i.e. the new version.
git add .

COMMIT_MSG=''

# If trigger repo is not an empty string
if [[ -n "$TRIGGER_REPO" ]]; then
  COMMIT_MSG="Automated: Build docs and demos $SHA (Triggered by $AUTHOR_NAME on $ORG_NAME/$TRIGGER_REPO@$TRIGGER_SHA)"
else
  COMMIT_MSG="Automated: Build docs and demos $SHA"
fi

# Apply and deploy commit IF there are changes
if [ -n "$(git status --porcelain)" ]; then
  git commit -m "$COMMIT_MSG"

  # Get the deploy key by using Travis's stored variables to decrypt travis_deploy_key.enc
  openssl aes-256-cbc -K $encrypted_7d4070ac53ae_key -iv $encrypted_7d4070ac53ae_iv -in travis_deploy_key.enc -out travis_deploy_key -d
  chmod 600 travis_deploy_key
  eval `ssh-agent -s`
  ssh-add travis_deploy_key

  # Push to branch
  git push -f $SSH_REPO master

  echo "Pushed deployment successfully"
else
  echo "Nothing to commit"
fi
