# Run integration tests on Linux

set -e

sudo apt-get -qq update -y
wget https://swift.org/builds/swift-4.1-release/ubuntu1404/swift-4.1-RELEASE/swift-4.1-RELEASE-ubuntu14.04.tar.gz -q
tar xzf swift-4.1-RELEASE-ubuntu14.04.tar.gz
export PATH=swift-4.1-RELEASE-ubuntu14.04/usr/bin:$PATH

# Decrypt credentials files
openssl aes-256-cbc -K $encrypted_d84ac0b7eb5c_key -iv $encrypted_d84ac0b7eb5c_iv -in Source/SupportingFiles/WatsonCredentials.swift.enc -out Source/SupportingFiles/WatsonCredentials.swift -d
openssl aes-256-cbc -K $encrypted_d84ac0b7eb5c_key -iv $encrypted_d84ac0b7eb5c_iv -in Tests/CompareComplyV1Tests/Resources/cloud-object-storage-credentials-input.json.enc -out Tests/CompareComplyV1Tests/Resources/cloud-object-storage-credentials-input.json -d
openssl aes-256-cbc -K $encrypted_d84ac0b7eb5c_key -iv $encrypted_d84ac0b7eb5c_iv -in Tests/CompareComplyV1Tests/Resources/cloud-object-storage-credentials-output.json.enc -out Tests/CompareComplyV1Tests/Resources/cloud-object-storage-credentials-output.json -d

swift build
# swift test