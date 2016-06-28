These instructions describe how to encrypt the internal `Credentials.plist` file. These credentials are required to build all test targets.

By following the steps below, you will commit an encrypted version of the credentials to the repository. This makes it safely accessibly to the Travis build environment for continuous integration.

#### Set Up Travis Utility

1. Install travis: `sudo gem install travis`
2. Login with travis: `travis login --org`

#### Encrypt File

1. Remove current decryption command in `.travis.yml`.
2. Encrypt credentials file and update build settings: `travis encrypt-file Credentials.plist --add --org`
3. Verify that `Credentials.plist.enc` is encrypted.
4. Verify the `.travis.yml` build settings.
5. Commit changes. Be careful not to accidentally commit `Credentials.plist`!
