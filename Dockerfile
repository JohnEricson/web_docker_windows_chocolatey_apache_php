FROM mcr.microsoft.com/windows/servercore:ltsc2019 

# https://github.com/StefanScherer/dockerfiles-windows/blob/master/chocolatey/Dockerfile
ENV chocolateyUseWindowsCompression false

# This requires working DNS in Docker daemon. On Windows I had to add this to docker/daemon.json: "dns": ["8.8.8.8"]
RUN powershell -Command \
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress

#RUN choco install apache-httpd --version=2.4.38 -y --params '"/installLocation:C:\app\apache /serviceName:web_apache /port:80"'

RUN mkdir "C:/Temp/Chocolatey packages"
COPY ["original_packages", "C:/Temp/Chocolatey packages"]
COPY ["packages", "C:/Temp/Chocolatey packages"]
RUN choco install apache-httpd --version=2.4.46 -y --params '"/installLocation:C:\app\apache /serviceName:web_apache /port:80 /noApacheDir"' --source "C:\Temp\Chocolatey packages;https://chocolatey.org/api/v2/"

# Only to test default behavior for pull request. https://github.com/chocolatey-community/chocolatey-coreteampackages/issues/1387
#RUN choco install apache-httpd --version=2.4.38 -y

#RUN choco install php --version=7.2.17 -y --params '"/ThreadSafe /InstallDir:C:\app\php"'

# Test to upgrade apache-httpd
#RUN choco upgrade apache-httpd -y --params '"/installLocation:C:\app\apache /serviceName:web_apache /port:80 /noApacheDir"' --source "C:\Temp\Chocolatey packages;https://chocolatey.org/api/v2/"


