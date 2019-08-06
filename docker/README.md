## Docker
You can use docker to test issues you have with the SDK.

1.  Install docker
    -   Mac: <https://docs.docker.com/docker-for-mac/install/>
    -   Windows: <https://docs.docker.com/docker-for-windows/install/>

2.  Download the dockerfile for this SDK and edit as needed.
    -   Change the swift version as needed `FROM swift:<your-version>`
        -   For valid swift base images on docker see <https://hub.docker.com/_/swift>

    -   Copy code/project that you wish to test into the dockerfile 
        -   Add line `COPY <src>... <dest>` to copy file into project ( make sure to add this line before `swift build` )
        -   App Path: `/app/sources/app`
        -   Tests Path: `/app/tests/appTests`

    -   Set dockerfile to execute code  
        -   Add line `CMD [ "<executable>" ]`
    
    -   For more information on dockerfile construction please visit <https://docs.docker.com/engine/reference/builder/>

3.  Build and run the docker image.
    -   Navigate to docker file directory
    -   To build the docker image run `docker build --tag=<your-tag> .`
    -   To run the docker image run `docker run <your-tag>`
