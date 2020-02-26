# escape=`

ARG BASE_IMAGE
ARG BUILD_IMAGE
ARG TOOLING_IMAGE

FROM ${BUILD_IMAGE} as build
FROM ${TOOLING_IMAGE} as tooling
FROM ${BASE_IMAGE} as release

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\inetpub\wwwroot

# Copy tools
COPY --from=tooling /tools/ /tools/

# Copy built website files
COPY --from=build /artifacts/files/ ./

# Find transform files and do transformation
RUN $xdts = Get-ChildItem -Path '.\\*.xdt' -Recurse; `
    $xdts | ForEach-Object { & 'C:\\tools\\scripts\\Invoke-XdtTransform.ps1' -Path $_.FullName.Replace('.xdt', '') -XdtPath $_.FullName; }; `
    $xdts | ForEach-Object { Remove-Item -Path $_.FullName; };

# OPTION 1 - Allow TDS to install on startup, knowing this will be done on EVERY container create
# Copy WDP item packages and extract to web root
COPY --from=build /artifacts/packages/ /temp/
RUN Get-ChildItem -Path 'C:\\temp\\*.wdp.zip' | % { Expand-Archive -Path $_.FullName -DestinationPath 'C:\\temp' -Force; }; `
    Move-Item -Path 'C:\\temp\\Content\\Website\\Bin\*' -Destination .\bin -Force; `
    Move-Item -Path 'C:\\temp\\Content\\Website\\temp\*' -Destination .\temp -Force; `
    Remove-Item -Path 'C:\\temp' -Recurse -Force;

# OPTION 2 - Invoke Deploy-TdsWdpPackages.ps1 on the container as-needed (similar to Unicorn sync) i.e. as part of your deployment script
# Copy WDP item packages and deployment script
#COPY --from=build /artifacts/packages/ /install/TdsPackages/
#COPY --from=tooling /tools/scripts/Deploy-TdsWdpPackages.ps1 /install/Deploy-TdsWdpPackages.ps1

# Remove tools
RUN Remove-Item -Path 'C:\\tools' -Recurse -Force;

FROM release as debug

# Copy tools
COPY --from=tooling /tools/ /tools/