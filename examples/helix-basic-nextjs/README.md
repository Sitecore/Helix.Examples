# Running the Example

## Prerequisites

* NodeJs 14.x
* .NET Core 3.1 SDK
* .NET Framework 4.8 SDK
* Visual Studio 2019
* Docker for Windows, with Windows Containers enabled

Ensure you have followed the steps listed on the [installation documentation](https://sitecore.github.io/Helix.Examples/install.html).

The Helix examples assume you have some experience with (or at least an understanding of) Docker container-based Sitecore development. For more information, see the [Sitecore Containers Documentation](https://containers.doc.sitecore.com).


## Initialize

Open a PowerShell administrator prompt and run the following command, replacing the `-LicenseXmlPath` with the location of your Sitecore license file.

```ps1
.\init.ps1 -InitEnv -LicenseXmlPath "C:\path\to\license.xml" -AdminPassword "DesiredAdminPassword"
```

This will perform any necessary preparation steps, such as populating the Docker Compose environment (.env) file, configuring certificates, and adding hosts file entries.

If this is your first time using `mkcert` with NodeJs, you will
need to set the `NODE_EXTRA_CA_CERTS` environment variable. This variable
must be set in your user or system environment variables. The `init.ps1`
script will provide instructions on how to do this.
  * Be sure to restart your terminal or VS Code for the environment variable
    to take effect.

## Build the solution and start Sitecore

Next run the following command.

```ps1
.\up.ps1
```

This will download any required Docker images, build the solution and Sitecore runtime images, and then start the containers. The example uses the *Sitecore Experience Platform Standalone (XP0)* topology.

Once complete, you can access the instance with the following.

* Sitecore Content Management: https://cm.basic-company-nextjs.localhost
* Sitecore Identity Server: https://id.basic-company-nextjs.localhost
* Basic Company site: https://www.basic-company-nextjs.localhost

## Rebuild Indexes

After running `.\up.ps1` for the first time, or if you ever run `\docker\clean.ps1`, you will need to [rebuild the search indexes](https://doc.sitecore.com/developers/101/platform-administration-and-architecture/en/rebuild-search-indexes.html).

You should now be able to view the Basic Company site at https://www.basic-company-nextjs.localhost.

## Stop Sitecore

When you're done, stop and remove the containers using the following command.

```
docker-compose down
```