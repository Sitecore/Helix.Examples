---
layout: page
hide_hero: true
---
# Installing / Running the Examples

While these examples are intended to be for **developer reference**, it
can be very helpful to see these examples deployed and running in a Sitecore
instance.

1. Ensure you have the prerequisites installed for Sitecore 9.2.0, including:
    * SQL Server 2016 SP2 or 2017
    * Apache Solr 7.5.0 with SSL enabled
    * .NET Framework 4.7.2
1. [Clone the full repository](https://github.com/Sitecore/Helix.Examples) or [download it](https://github.com/Sitecore/Helix.Examples/archive/master.zip) and unzip into a local directory.
1. Download the on-premises XP Single (XP0) packages from
[dev.sitecore.net](https://dev.sitecore.net/Downloads/Sitecore_Experience_Platform/92/Sitecore_Experience_Platform_92_Initial_Release.aspx) and, without unzipping, place the package into the `install-assets` folder of the repository.
    * `Sitecore 9.2.0 rev. 002893 (WDP XP0 packages).zip`
1. Place your `license.xml` into the `install-assets` folder of the repository.
1. Run `.\install.ps1` from an Administrator PowerShell prompt, and follow the instructions.