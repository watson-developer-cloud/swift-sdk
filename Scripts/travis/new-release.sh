# Uses the semantic-release tool to automatically release a new version to Github
# Includes:
	# New git tag
	# Github release with release notes and an attached pre-built SDK
	# Updated CHANGELOG
	# Updated version number in source files

set -e

sudo easy_install pip
source ~/.nvm/nvm.sh
nvm install 10
sudo pip install bumpversion
npm install -g semantic-release@15.9.0
npm install -g @semantic-release/exec
npm install -g @semantic-release/changelog
npm install -g @semantic-release/git
brew update
brew outdated carthage || brew upgrade carthage

carthage update --platform iOS
npx semantic-release