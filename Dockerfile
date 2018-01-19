FROM swiftdocker/swift:4.0
ADD . /SwiftSDK
WORKDIR /SwiftSDK
RUN rm -rf /SwiftSDK/.build/debug && swift package resolve && swift package clean
CMD swift test
