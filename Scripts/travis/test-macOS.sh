# Run pod lint and integration tests on macOS

set -e

# Decrypt credentials files
openssl aes-256-cbc -K $encrypted_451e23e8cd1f_key -iv $encrypted_451e23e8cd1f_iv -in Source/SupportingFiles/WatsonCredentials.swift.enc -out Source/SupportingFiles/WatsonCredentials.swift -d
openssl aes-256-cbc -K $encrypted_d84ac0b7eb5c_key -iv $encrypted_d84ac0b7eb5c_iv -in Tests/CompareComplyV1Tests/Resources/cloud-object-storage-credentials-input.json.enc -out Tests/CompareComplyV1Tests/Resources/cloud-object-storage-credentials-input.json -d
openssl aes-256-cbc -K $encrypted_d84ac0b7eb5c_key -iv $encrypted_d84ac0b7eb5c_iv -in Tests/CompareComplyV1Tests/Resources/cloud-object-storage-credentials-output.json.enc -out Tests/CompareComplyV1Tests/Resources/cloud-object-storage-credentials-output.json -d

carthage bootstrap --platform iOS

./Scripts/pod-lint.sh
./Scripts/run-tests.sh
