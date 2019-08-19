# Generate API docs and upload them to Github on the gh-pages branch
# IMPORTANT: This is only meant to be called from Travis builds!

set -e

if [ "$is_travis" = "TRAVIS" ]; then
    gem install jazzy

    # Configure Travis to be able to push to the Github repo
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
    git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
    git remote rm origin
    git remote add origin https://watson-developer-cloud:${GH_TOKEN}@github.com/watson-developer-cloud/swift-sdk.git
fi

git fetch
git checkout master
latestVersion=$(git describe --abbrev=0 --tags)

git clone --quiet --branch=gh-pages https://github.com/watson-developer-cloud/swift-sdk.git gh-pages > /dev/null

# Delete all the old docs (but not the docs directory -- this is hand written)
(cd gh-pages && git rm -rf css img index.html js services undocumented.json)

# Generate the API docs
./Scripts/generate-documentation.sh gh-pages

# Commit and push the newly generated API docs
pushd gh-pages
  git add .
  git commit -m "SDK docs for release ${latestVersion}"
  git push
popd
