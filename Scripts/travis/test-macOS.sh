# Run pod lint and integration tests on macOS

set -e

brew update >/dev/null
brew outdated carthage || brew upgrade carthage >/dev/null
openssl aes-256-cbc -K $encrypted_d84ac0b7eb5c_key -iv $encrypted_d84ac0b7eb5c_iv -in Source/SupportingFiles/WatsonCredentials.swift.enc -out Source/SupportingFiles/WatsonCredentials.swift -d

pod repo update master --silent # Gets the latest version of RestKit
carthage update --platform iOS

./Scripts/pod-lint.sh
# ./Scripts/run-tests.sh