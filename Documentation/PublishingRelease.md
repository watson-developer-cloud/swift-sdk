The following tasks should be completed before publishing a release. Track the progress of the release by copying and pasting the tasks below into an issue for the release.

#### Github and Project Planning

- [ ] Review pull requests and merge as appropriate.
- [ ] Review the issues assigned to the release's milestone.

#### User Agent

- [ ] Use find-and-replace to update the version number in the `userAgent` prefixes.
- [ ] Temporarily make `userAgent` a required parameter to `RestRequest`.

#### Tests and Verification

- [ ] Run all tests to verify correctness. Fix any errors.
- [ ] Verify that all necessary changes to `.travis.yml` have been made.
- [ ] If changes were made to Speech to Text then test continuous streaming support on a physical device.

#### Documentation

- [ ] Update the `generateDocumentation.sh` script for any new targets/services.
- [ ] Generate documentation for the gh-pages branch using `generateDocumentation.sh`.
- [ ] Fix any undocumented code. Then re-generate the gh-pages documentation.
- [ ] Update the change log.
- [ ] Update the readme.

#### Publish Release

- [ ] Use Github to create a tag/release.
- [ ] Ensure that Carthage successfully builds each service's framework.
- [ ] Celebrate the team's hard work! :)
