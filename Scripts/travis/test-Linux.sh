# Run integration tests on Linux

sudo apt-get -qq update -y
wget https://swift.org/builds/swift-4.2.4-release/ubuntu1604/swift-4.2.4-RELEASE/swift-4.2.4-RELEASE-ubuntu16.04.tar.gz -q
tar xzf swift-4.2.4-RELEASE-ubuntu16.04.tar.gz
export PATH=swift-4.2.4-RELEASE-ubuntu16.04/usr/bin:$PATH

# Decrypt credentials files
openssl aes-256-cbc -K $encrypted_d84ac0b7eb5c_key -iv $encrypted_d84ac0b7eb5c_iv -in Sources/SupportingFiles/WatsonCredentials.swift.enc -out Sources/SupportingFiles/WatsonCredentials.swift -d

swift build
# swift test
