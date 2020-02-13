# escape=`

ARG TOOLING_BUILD_IMAGE
ARG TOOLING_BASE_IMAGE

FROM ${TOOLING_BUILD_IMAGE} as build

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# copy local assets
COPY . .\

# download remote assets
RUN New-Item -Path 'C:\\setup' -ItemType 'Directory' -Force | Out-Null; `
    Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/v5.2.0/nuget.exe" -OutFile C:\setup\nuget.exe; `
    Invoke-WebRequest -Uri "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.1-windows-x86_64.zip" -OutFile C:\setup\filebeat.zip; `
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.3.0/sitecore-assets/tools/entrypoints/iis/Development.ps1" -OutFile C:\tools\scripts\Development.ps1; `
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.3.0/sitecore-assets/tools/entrypoints/iis/EnableUdpLogging.config" -OutFile C:\tools\scripts\EnableUdpLogging.config; `
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.3.0/sitecore-assets/tools/entrypoints/iis/filebeat.yml" -OutFile C:\tools\scripts\filebeat.yml; `
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.2.0/sitecore-assets/tools/scripts/Watch-Directory.ps1" -OutFile C:\tools\scripts\Watch-Directory.ps1;
    # note we're copying the 9.2.0 version of Watch-Directory due to this issue: https://github.com/Sitecore/docker-images/issues/89

# install filebeat, microsoft xdt assembly, and cleanup
RUN Expand-Archive -Path 'C:\\setup\\filebeat.zip' -DestinationPath 'C:\\tools\\bin' -Force; `
    Rename-Item -Path (Get-Item -Path 'C:\\tools\\bin\\filebeat*windows*').FullName -NewName "filebeat" -Force -ErrorAction SilentlyContinue; `
    & 'C:\\setup\\nuget.exe' install 'Microsoft.Web.Xdt' -Version '3.0.0' -OutputDirectory 'C:\\setup'; `
    Copy-Item -Path 'C:\\setup\\Microsoft.Web.Xdt*\\lib\\netstandard2.0\\*.dll' -Destination 'C:\\tools\\bin'; `
    Remove-Item -Recurse -Force C:\setup;

FROM ${TOOLING_BASE_IMAGE}

COPY --from=build \tools .\tools