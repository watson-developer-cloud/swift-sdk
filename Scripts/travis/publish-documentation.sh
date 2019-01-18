# Generate API docs and upload them to Github on the gh-pages branch
# IMPORTANT: This is only meant to be called from Travis builds!

set -e

gem install jazzy --silent

# Configure Travis to be able to push to the Github repo
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git remote rm origin
git remote add origin https://watson-developer-cloud:${GH_TOKEN}@github.com/watson-developer-cloud/swift-sdk.git
git fetch
git checkout master
latestVersion=$(git describe --abbrev=0 --tags)

# Generate the API docs
./Scripts/generate-documentation.sh

# Push newly-generated docs to the gh-pages branch
git checkout --track origin/gh-pages
cp -r gh-pages/* .
rm -rf gh-pages/
git add .
git commit -m "SDK docs for release ${latestVersion}"
git push --set-upstream origin gh-pages
