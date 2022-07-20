# escape=`

ARG PARENT_IMAGE
ARG HEADLESS_SERVICES_IMAGE

FROM ${HEADLESS_SERVICES_IMAGE} AS headless_services
FROM ${PARENT_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add Headless Services module
COPY --from=headless_services /module/db /jss_data
