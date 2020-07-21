# escape=`

ARG BASE_IMAGE
ARG BUILD_IMAGE

FROM ${BUILD_IMAGE} AS prep

# Gather only artifacts necessary for NuGet restore, retaining directory structure
COPY *.sln nuget.config Directory.Build.targets Packages.props \nuget\
COPY src\ \temp\
RUN Invoke-Expression 'robocopy C:\temp C:\nuget\src /s /ndl /njh /njs *.csproj *.scproj packages.config'

FROM ${BUILD_IMAGE} AS builder

# TDS licensing via environment variables: https://hedgehogdevelopment.github.io/tds/chapter5.html#sitecore-tds-builds-using-cloud-servers
ARG TDS_Owner
ARG TDS_Key

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Create an empty working directory
WORKDIR C:\build

# Copy prepped NuGet artifacts, and restore as distinct layer to take better advantage of caching
COPY --from=prep .\nuget .\
RUN nuget restore -Verbosity quiet

# Copy remaining source code
COPY TdsGlobal.config .\
COPY src\ .\src\

# Copy transforms, retaining directory structure
RUN Invoke-Expression 'robocopy C:\build\src C:\out\transforms /s /ndl /njh /njs *.xdt'

# Build using Release configuration
RUN msbuild /p:Configuration=Release

FROM ${BASE_IMAGE}

WORKDIR C:\artifacts

# Build output will land at the location specified in TDS projects (the "Build Output Path"), relative to our builder's WORKDIR
# As configured, this means our build output will be:
#	C:\build\TdsGeneratedPackages\Release -> files
#	C:\build\TdsGeneratedPackages\WebDeploy_Release -> WDP item packages

# Copy build artifacts
COPY --from=builder C:\build\TdsGeneratedPackages\Release .\website\
COPY --from=builder C:\build\TdsGeneratedPackages\WebDeploy_Release .\packages\
COPY --from=builder C:\out\transforms .\transforms\