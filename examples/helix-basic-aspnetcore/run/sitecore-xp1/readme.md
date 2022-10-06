# Issues in Execution in XP1 mode

## Traefik container is unhealthy

```
ERROR: for traefik  Container is unhealthy.
ERROR: Encountered errors while bringing up the project.
Waiting for CM to become available...
```

## Logs from xdbautomationworker container

Getting below on xdbautomationworker container

```

Starting Marketing Automation Engine...
Engine started.

Press Ctrl+C or Ctrl+Break to exit
2022-10-01 12:32:03 ERR Health check "reference data sql" completed after 2402.0615ms with status Unhealthy and '"Error message: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server)"'
2022-10-01 12:32:03.445 +00:00 [Error] Health check "reference data sql" completed after 2402.0615ms with status Unhealthy and '"Error message: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server)"'

```

## Thoughts

I think so this is license issue (am using partner license) because same user and password are being used to connect other databases.
