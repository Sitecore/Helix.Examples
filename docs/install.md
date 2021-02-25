---
layout: page
hide_hero: true
---
# Installing / Running the Examples

While these examples are intended to be for **developer reference**, it
can be very helpful to see these examples deployed and running in a Sitecore
instance.

1. Ensure your [environment is set up for container-based Sitecore development](https://containers.doc.sitecore.com/docs/environment-setup), including:
   * Hardware guidelines are met
   * Docker Desktop is installed
   * You've switched to Windows containers
1. The default Sitecore container configuration uses specific ports. To avoid any conflicts, ensure the following ports are not being used by another process: **443, 8079, 8081, 8984, and 14330**.
1. You'll need a Sitecore license file `license.xml` handy. 
   * If you do not have one, please reach out to your Sitecore contact.
1. [Clone the full repository](https://github.com/Sitecore/Helix.Examples) or [download it](https://github.com/Sitecore/Helix.Examples/archive/master.zip) and unzip into a local directory.
1. Follow the `README.md` instructions for each example.
   1. [Helix Basic Company - ASP.NET Core](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-aspnetcore/README.md)
   1. [Helix Basic Company - Next.js](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-nextjs/README.md)
   1. [Helix Basic Company - TDS](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-tds/README.md)
   1. [Helix Basic Company - TDS Consolidated](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-tds-consolidated/README.md)
   1. [Helix Basic Company - Unicorn](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-unicorn/README.md)