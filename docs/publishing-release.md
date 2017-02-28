The following tasks should be completed before publishing a release. Track the progress of the release by copying and pasting the tasks below into an issue for the release.

#### Github and Project Planning

- [ ] Review and merge any outstanding pull requests.
- [ ] Review any oustanding issues assigned to this release milestone.

#### Source Changes

- [ ] Update the `sdkVersion` property in `RestRequest.swift`.
- [ ] Add any new targets/services to `Package.swift`.

#### Tests and Verification

- [ ] Run all tests to verify correctness. Fix any errors.
- [ ] Update `.travis.yml` for any new targets/services.
- [ ] Encrypt `Credentials.swift` to support any new targets/services with Travis.
- [ ] If changes were made to Speech to Text, then test continuous streaming support on a physical device.

#### Documentation

- [ ] Update the `generate-documentation.sh` script for any new targets/services.
- [ ] Execute the `generate-documentation.sh` script to update the API documentation.
- [ ] Update the `docs/index.html` page to add any new services and/or change the date. Consider opening an issue to automate this. 
- [ ] Check `undocumented.json` for any missing documentation comments. Make the necessary changes then re-run the `generate-documentation.sh` script.
- [ ] Update `CHANGELOG.md`.
- [ ] Update `README.md`.

#### Publish Release

- [ ] Use Github to create a tag/release.
- [ ] Execute the `generate-binaries.sh` script to build and archive frameworks into a `WatsonDeveloperCloud.framework.zip` file. Then attach `WatsonDeveloperCloud.framework.zip` to the GitHub release.
- [ ] Test that Carthage successfully builds each service's framework.
- [ ] Test that the documentation badge includes the service(s) added, if any.
- [ ] Celebrate the team's hard work! :)
