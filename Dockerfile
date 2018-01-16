FROM swiftdocker/swift
ADD . /SwiftSDK
WORKDIR /SwiftSDK
RUN swift package resolve
RUN swift package clean
Run swift build
CMD swift test
