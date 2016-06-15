#!/bin/bash

# Exit with nonzero exit code if anything fails
set -e

# Borrowed from https://gist.github.com/kamranayub/ca7b6866ab43771d9da8#file-deploy-sh and https://gist.github.com/domenic/ec8b0fc8ab45f39403dd
echo "Running deployment script..."

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`
MANIFEST_FILE_NAME="./wearefine.github.io.manifest.txt"
REPOS_TO_COMPILE='fae fryr fine-forever frob-core maximus'

mkdir _git_src
cd _git_src

# Clone repos to compile
for repo_name in $REPOS_TO_COMPILE; do
  git clone -b master "https://github.com/wearefine/${repo_name}.git"

  # Enter cloned repo
  cd "$repo_name"

  # Search for manifest file
  if [ -e "$MANIFEST_FILE_NAME" ]; then
    # Copy relevant files specified in child repo, going line-by-line
    while read path_name; do
      # If it's a README, ignore.
      if [ "$path_name" == "README.md" ]; then
        cp "./$path_name" "../../$repo_name/index.md"
      else
        cp -r "./$path_name" "../../$repo_name/$path_name"
      fi
    done < "$MANIFEST_FILE_NAME"
  else
    echo "Manifest not found for $repo_name"
  fi

  # Return to _git_src directory
  cd ..
done

# Return to root directory
cd ..

# Destroy cloned repos
# This doesn't always remove the folder, so be sure to include it in .gitignore
rm -rf _git_src

git config user.name "Travis-CI"
git config user.email "travis-ci@wearefine.com"

# Commit the "changes", i.e. the new version.
git add .
git commit -m "Automated: Build docs and demos $SHA"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}

ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in deploy_key.enc -out deploy_key -d
chmod 600 deploy_key
eval `ssh-agent -s`
ssh-add deploy_key

# Push to branch
git push $SSH_REPO master

echo "Pushed deployment successfully"
