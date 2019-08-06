#Import swift base image ( change version as needed )
FROM swift:latest

#Move to the swift docker app directory
WORKDIR /app

#Create new swift project which can be executed in the command line
RUN swift package init --type executable

#Copy swift package dependencies into the project
COPY Package.swift .

#Build swift project to install sdk
RUN swift build
