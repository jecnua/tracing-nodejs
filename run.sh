#!/bin/bash
# NAME_REPO will be deduced by the git repo name.
# You can override this behaviour by setting the variable to something.

if [ ! -d .git ]
then
  echo "This is not a git repo. Exiting."
  exit 1
fi

if [ -z "${NAME_REPO+x}" ];
then
  echo "NAME_REPO is unset";
  NAME_REPO=$(basename "$(git rev-parse --show-toplevel)" | sed 's/-/\//g')
  echo "NAME_REPO is now set to '$NAME_REPO'";
else
  echo "NAME_REPO is set to '$NAME_REPO'";
fi

# By default use dockerhub
URL=$NAME_REPO

## Uncomment this if you want to create a new repo on ECR
# ALL=`aws ecr describe-repositories`
# TEST=`echo $ALL | grep $NAME_REPO | wc -l`
# echo "Checking $NAME_REPO"
# if [[ $TEST -eq 0 ]]
# then
#   echo 'Repository NOT found on aws. Creating:'
#   aws ecr create-repository --repository-name $NAME_REPO
# else
#   echo 'Repository found on aws'
# fi
#
# URL=`aws ecr describe-repositories | grep $NAME_REPO | grep repositoryUri | cut -d ':' -f 2 | cut -d '"' -f 2`
# echo "Repository url: $URL"

cat << EOF > env.sh
#!/bin/bash
export DOCKER_IMAGE=$NAME_REPO
export URL_REPO=$URL
EOF

echo "Env file generated in env.sh"
