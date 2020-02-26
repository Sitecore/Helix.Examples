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

# Remove tools
RUN Remove-Item -Path 'C:\\tools' -Recurse -Force;

FROM release as debug

# Copy tools
COPY --from=tooling /tools/ /tools/