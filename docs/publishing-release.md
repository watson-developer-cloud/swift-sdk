The following tasks should be completed before publishing a release. Track the progress of the release by copying and pasting the tasks below into an issue for the release.

#### Github and Project Planning

- [ ] Review and merge any outstanding pull requests.
- [ ] Review any oustanding issues assigned to this release milestone.

#### Publishing a New Service

- [ ] Add service to `README.md`
- [ ] Add service to `Package.swift`
- [ ] Add service to `Tests/LinuxMain.swift`
- [ ] Add service to `generate-documentation.md` script
- [ ] Add service to `Scripts/run-tests.sh` script
- [ ] Add service credentials to `Credentials.swift` and `CredentialsExample.swift`
- [ ] Upload encrypted `Credentials.swift` to Travis (see [encrypt-credentials.md](encrypt-credentials.md))

#### Source Code and Tests

- [ ] Update the `sdkVersion` property in `RestRequest.swift`.
- [ ] Test all services and fix any errors.
- [ ] Test continuous streaming with Speech to Text on a physical device.

#### Documentation

- [ ] Update `README.md`.
- [ ] Update `CHANGELOG.md`.
- [ ] Execute the `Scripts/generate-documentation.sh` script to update the API documentation. If `undocumented.json` shows any missing documentation comments, be sure to add them then re-run the script.

#### Publish Release

**Note**: Perform these steps in your side branch, *after* getting approvals on your code reviews, but *before* merging your pull request to master.

- [ ] Create a new git tag (with the new version) on the latest commit in master, and push to Github
- [ ] [**Optional**] If you haven't done so, get set up with [Cocoapods Trunk](https://guides.cocoapods.org/making/getting-setup-with-trunk.html). You will need to be given permissions by an owner of this SDK to release to Cocoapods.
- [ ] Execute `Scripts/release.sh` to publish new version to Cocoapods and build the SDK archive `WatsonDeveloperCloud.framework.zip`.
**IMPORTANT**: Make sure you understand how the `release.sh` script works before using it! It can be dangerous. If in doubt, go through the manual release process for Cocoapods, and run `Scripts/generate-binaries` to build the zip file.
- [ ] Attach `WatsonDeveloperCloud.framework.zip` to the new Github release
- [ ] Add release notes on Github, explaining what changed in this version 
- [ ] Test that the new version can be successfully installed in a new app using Carthage and Cocoapods
- [ ] Merge to master!
