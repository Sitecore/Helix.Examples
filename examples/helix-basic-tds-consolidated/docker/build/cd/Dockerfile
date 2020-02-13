# escape=`

ARG TOOLING_IMAGE
ARG BASE_IMAGE

FROM ${TOOLING_IMAGE} as tooling
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# copy out tools
COPY --from=tooling \tools C:\\tools

# grab local build files
COPY . .\

# perform xdt transforms
RUN C:\tools\scripts\Invoke-XdtTransformations.ps1 -TargetPath C:\inetpub\wwwroot -XdtPath .\xdts -XdtDllPath C:\tools\bin\Microsoft.Web.XmlTransform.dll