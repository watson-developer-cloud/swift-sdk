FROM swiftdocker/swift:4.0
ADD . /SwiftSDK
WORKDIR /SwiftSDK
RUN swift package resolve && swift package clean
CMD swift test
