# escape=`

ARG TOOLING_BASE_IMAGE
ARG TOOLING_BUILD_IMAGE

FROM ${TOOLING_BUILD_IMAGE} as build

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Create working directories
RUN New-Item -Path 'C:\\temp' -ItemType 'Directory' -Force | Out-Null; `
    New-Item -Path 'C:\\tools' -ItemType 'Directory' -Force | Out-Null;

# Install NuGet
ADD https://dist.nuget.org/win-x86-commandline/v5.2.0/nuget.exe /temp/

# Install Filebeat
RUN Invoke-WebRequest -Uri "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.1-windows-x86_64.zip" -OutFile C:\\temp\\filebeat.zip; `
    Expand-Archive -Path 'C:\\temp\\filebeat.zip' -DestinationPath 'C:\\tools\\bin' -Force; `
    Rename-Item -Path (Get-Item -Path 'C:\\tools\\bin\\filebeat*windows*').FullName -NewName "filebeat" -Force -ErrorAction SilentlyContinue; `
    Remove-Item -Path 'C:\\temp\\filebeat.zip' -Force;

# Install Microsoft XDT assembly
RUN & 'C:\\temp\\nuget.exe' install 'Microsoft.Web.Xdt' -Version '3.0.0' -OutputDirectory 'C:\\temp'; `
    Copy-Item -Path 'C:\\temp\\Microsoft.Web.Xdt*\\lib\\netstandard2.0\\*.dll' -Destination 'C:\\tools\\bin'; `
    Remove-Item -Path (Get-Item -Path 'C:\\temp\\Microsoft.Web.Xdt*\\').FullName -Recurse -Force;

# Copy local tools
COPY /tools/ /tools/

# Grab remainder from community (for now)
ADD https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.3.0/sitecore-assets/tools/entrypoints/iis/Development.ps1 /tools/entrypoints/iis/
ADD https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.3.0/sitecore-assets/tools/entrypoints/iis/EnableUdpLogging.config /tools/entrypoints/iis/
ADD https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.3.0/sitecore-assets/tools/entrypoints/iis/filebeat.yml /tools/entrypoints/iis/
# Note we're copying the 9.2.0 version of Watch-Directory due to this issue: https://github.com/Sitecore/docker-images/issues/89
ADD https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.2.0/sitecore-assets/tools/scripts/Watch-Directory.ps1 /tools/scripts/
ADD https://raw.githubusercontent.com/Sitecore/docker-images/master/windows/9.3.0/sitecore-assets/tools/scripts/Invoke-XdtTransform.ps1 /tools/scripts/

FROM ${TOOLING_BASE_IMAGE}

# Copy resulting tools
COPY --from=build /tools/ /tools/