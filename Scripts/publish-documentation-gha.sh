# Generate API docs and upload them to Github on the gh-pages branch

set -e

gem install jazzy

printf "\n>>>>> Cloning repository's gh-pages branch into directory 'gh-pages'\n"
git config --global user.email "watdevex@us.ibm.com"
git config --global user.name "watdevex"
git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/watson-developer-cloud/swift-sdk.git gh-pages > /dev/null
printf "\n>>>>> Finished cloning...\n"

latestVersion=$(git describe --abbrev=0 --tags)

# Delete all the old docs (but not the docs directory -- this is hand written)
printf "\n>>>>> Delete all the old docs\n"
(cd gh-pages && rm -rf css img index.html js services undocumented.json)

# Generate the API docs
printf "\n>>>>> Generating the docs using jazzy\n"
./Scripts/generate-documentation.sh gh-pages

# Commit and push the newly generated API docs
printf "\n>>>>> Committing new javadoc for version: %s\n" ${latestVersion}

pushd gh-pages
git add -f .
git commit -m "chore: SDK docs for release ${latestVersion}"
git push -f origin gh-pages
popd
