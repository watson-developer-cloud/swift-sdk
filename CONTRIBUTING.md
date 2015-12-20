This document contains information and guidelines about contributing to this project. Please read it before you start participating.

# Asking Questions

We don't use GitHub as a support forum. For any usage questions that are not specific to the project itself, please ask on [dW Answers][dw] or [Stack Overflow][stackoverflow]. By doing so, you'll be more likely to quickly solve your problem, and you'll also allow anyone else with the same question to find the answer.

# Reporting Issues

If you encounter a bug with the Watson Developer Cloud iOS SDK, please submit a detailed [issue](https://github.com/IBM-MIL/Watson-iOS-SDK/issues) so that it can be addressed quickly. We always appreciate a well-written, thorough bug report.

Please check that the project issues database doesn't already include that problem or suggestion before submitting an issue. If you find a match, add a quick "+1" or "I have this problem too." Doing so helps prioritize the most common problems and requests.

When reporting issues, please include the following:

* The version of Xcode you're using
* The version of iOS you're targeting
* The full output of any stack trace or compiler error
* A code snippet that reproduces the described behavior, if applicable
* Any other details that would be useful in understanding the problem.

This information will help us review and fix your issue faster.

# Pull Requests

If you want to contribute to the repository, here's a quick guide:
  1. Fork the repository.
  2. Develop and test your code changes. Be sure to build the project and run tests in the test navigator.
    * Respect the original code [style guide][styleguide].
    * Create minimal diffs - disable on save actions like reformat source code or organize imports. If you feel the source code should be reformatted create a separate PR for this change.
    * Check for unnecessary whitespace with `git diff --check` before committing.
  3. Ensure all tests pass successfully.
  4. Commit your changes.
  5. Push to your fork and submit a pull request to the **dev** branch.

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
