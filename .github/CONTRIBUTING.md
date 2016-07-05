This document contains information and guidelines about contributing to this project. Please read it before you start participating.

# Asking Questions

We don't use GitHub as a support forum. For any usage questions that are not specific to the project itself, please ask on [dW Answers][dw] or [Stack Overflow][stackoverflow]. By doing so, you'll be more likely to quickly solve your problem, and you'll also allow anyone else with the same question to find the answer.

# Reporting Issues

See the [issue template](issue_template.md).

# Pull Requests

If you want to contribute to the repository, here's a quick guide:
  1. Fork the repository.
  2. Copy `CredentialsExample.plist` to `Credentials.plist`.
  3. Add credentials to `Credentials.plist` for the services you plan to test.
  4. Develop and test your code changes.
    * Please respect the original code [style guide][styleguide].
    * Create minimal diffs - disable on save actions like reformat source code or organize imports. If you feel the source code should be reformatted create a separate PR for this change.
    * Check for unnecessary whitespace with `git diff --check` before committing.
  5. Verify that tests pass successfully.
  6. Push to your fork and submit a pull request to the **master** branch.

# Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
   have the right to submit it under the open source license
   indicated in the file; or

(b) The contribution is based upon previous work that, to the best
   of my knowledge, is covered under an appropriate open source
   license and I have the right under that license to submit that
   work with modifications, whether created in whole or in part
   by me, under the same open source license (unless I am
   permitted to submit under a different license), as indicated
   in the file; or

(c) The contribution was provided directly to me by some other
   person who certified (a), (b) or (c) and I have not modified
   it.

(d) I understand and agree that this project and the contribution
   are public and that a record of the contribution (including all
   personal information I submit with it, including my sign-off) is
   maintained indefinitely and may be redistributed consistent with
   this project or the open source license(s) involved.


## Additional Resources
+ [General GitHub documentation](https://help.github.com/)
+ [GitHub pull request documentation](https://help.github.com/send-pull-requests/)

[dw]: https://developer.ibm.com/answers/questions/ask/?topics=watson
[stackoverflow]: http://stackoverflow.com/questions/ask?tags=ibm-watson
[styleguide]: https://github.com/IBM-MIL/swift-style-guide

---

*Some of the ideas and wording for the statements above were based on work by the [Alamofire](https://github.com/Alamofire/Alamofire/blob/master/CONTRIBUTING.md), [Docker](https://github.com/docker/docker/blob/master/CONTRIBUTING.md), and [Linux](http://elinux.org/Developer_Certificate_Of_Origin) communities. We commend them for their efforts to facilitate collaboration in their projects.*
