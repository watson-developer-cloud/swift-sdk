# Run pod lint and integration tests on macOS

set -e

# Decrypt credentials files
openssl aes-256-cbc -K $encrypted_451e23e8cd1f_key -iv $encrypted_451e23e8cd1f_iv -in Sources/SupportingFiles/WatsonCredentials.swift.enc -out Sources/SupportingFiles/WatsonCredentials.swift -d

carthage bootstrap --platform iOS

./Scripts/pod-lint.sh
./Scripts/run-tests.sh
