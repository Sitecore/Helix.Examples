# escape=`

ARG BASE_IMAGE
ARG TOOLING_IMAGE
ARG SOLUTION_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${TOOLING_IMAGE} as tooling
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy development tools and entrypoint
COPY --from=tooling \tools\ \tools\

# Set the default location for serialized items
# This value is used in our Unicorn configuration
ENV ITEM_SYNC_LOCATION c:\items

# Copy serialized items and Unicorn sync script
COPY --from=solution \artifacts\items\ \items\
COPY .\unicorn \unicorn\

WORKDIR C:\inetpub\wwwroot

# Copy solution website files
COPY --from=solution \artifacts\website\ .\