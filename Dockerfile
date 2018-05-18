FROM swiftdocker/swift:4.1
ADD . /swift-sdk
WORKDIR /swift-sdk
RUN rm -rf /swift-sdk/.build/debug && swift package resolve && swift package clean
CMD swift test
