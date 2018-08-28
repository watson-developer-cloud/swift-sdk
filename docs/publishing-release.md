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

- [ ] After pull request is merged into master, create a new git tag on the latest commit in master, and push to Github
- [ ] Add release notes on Github, explaining what changed in this version
- [ ] Execute `Scripts/release.sh` to publish new version to Cocoapods and build the SDK archive `WatsonDeveloperCloud.framework.zip`
- [ ] Attach `WatsonDeveloperCloud.framework.zip` to the new Github release
- [ ] Test that the new version can be successfully installed in a new app using Carthage and Cocoapods
