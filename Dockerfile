FROM swiftdocker/swift
ADD . /SwiftSDK
WORKDIR /SwiftSDK
RUN swift package resolve
RUN swift package clean
CMD swift test
