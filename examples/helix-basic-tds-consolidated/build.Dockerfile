# escape=`

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS builder

# NuGet credentials (for SitecorePreview) via environment variables: https://github.com/dotnet/dotnet-docker/blob/master/samples/snippets/nuget-credentials.md
ARG Nuget_SitecorePreview_Username
ARG Nuget_SitecorePreview_Password

# TDS licensing via environment variables: https://hedgehogdevelopment.github.io/tds/chapter5.html#sitecore-tds-builds-using-cloud-servers
ARG TDS_Owner
ARG TDS_Key

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Create an empty working directory
WORKDIR /build

##########################################
# IDEAL: 
#   Copy csproj (and scproj) and restore NuGet packages as distinct layers to take better advantage of caching
#   Waiting on PackageReference support in TDS projects (coming soon) to make this a bit cleaner (don't need to worry about packages.config files)
##########################################
# COPY *.sln nuget.config ./
# # Copy csproj (and scproj) and restore NuGet packages as distinct layers
# COPY src/*/*.csproj ./
# RUN Get-ChildItem *.csproj | % { New-Item -ItemType Directory -Path "src/$($_.BaseName)"; Move-Item $_ -Destination "src/$($_.BaseName)"; }
# COPY src/*/*.scproj ./
# RUN Get-ChildItem *.scproj | % { New-Item -ItemType Directory -Path "src/$($_.BaseName)"; Move-Item $_ -Destination "src/$($_.BaseName)"; }
# RUN nuget restore
# 
# # Copy everything else and build
# COPY src/. ./src/
# RUN msbuild /p:Configuration=Release
#########################################

# Copy out source code. Note the companion .dockerignore is important to reduce our build context
COPY . ./

# Restore NuGet packages
RUN nuget restore

# Build using Release configuration
RUN msbuild /p:Configuration=Release

# Build output will land at the location specified in TDS projects (the "Build Output Path"), relative to our WORKDIR
# As configured, this means our build output will be:
#	C:\build\TdsGeneratedPackages\Release -> files
#	C:\build\TdsGeneratedPackages\WebDeploy_Release -> WDP item packages