# escape=`

ARG BASE_IMAGE
ARG BUILD_IMAGE

FROM ${BUILD_IMAGE} AS builder

# NuGet credentials (for SitecorePreview) via environment variables: https://github.com/dotnet/dotnet-docker/blob/master/samples/snippets/nuget-credentials.md
ARG Nuget_SitecorePreview_Username
ARG Nuget_SitecorePreview_Password

# TDS licensing via environment variables: https://hedgehogdevelopment.github.io/tds/chapter5.html#sitecore-tds-builds-using-cloud-servers
ARG TDS_Owner
ARG TDS_Key

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Create an empty working directory
WORKDIR /build

# Copy only artifacts necessary for NuGet, and restore as distinct layer to take better advantage of caching
COPY *.sln nuget.config ./
COPY src/*/*.csproj ./
RUN Get-ChildItem *.csproj | % { New-Item -ItemType Directory -Path "src/$($_.BaseName)"; Move-Item $_ -Destination "src/$($_.BaseName)"; } | Out-Null

# Note TDS .scproj files don't support PackageReference syntax, so these are a bit different in order to pull in packages.config as well
COPY src/BasicCompany.Items.Content/* ./src/BasicCompany.Items.Content/
COPY src/BasicCompany.Items.Core/*  ./src/BasicCompany.Items.Core/
COPY src/BasicCompany.Items.Master/* ./src/BasicCompany.Items.Master/

# Restore NuGet packages
RUN nuget restore

# Copy remaining source code
COPY src/ ./src/

# Build using release configuration
RUN msbuild /p:Configuration=Release

FROM ${BASE_IMAGE}

WORKDIR /artifacts

# Build output will land at the location specified in TDS projects (the "Build Output Path"), relative to our builder's WORKDIR
# As configured, this means our build output will be:
#	/build/TdsGeneratedPackages/Release -> files
#	/build/TdsGeneratedPackages/WebDeploy_Release -> WDP item packages

# Copy build artifacts
COPY --from=builder /build/TdsGeneratedPackages/Release ./files/
COPY --from=builder /build/TdsGeneratedPackages/WebDeploy_Release ./packages/