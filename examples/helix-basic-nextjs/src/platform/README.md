# Sitecore Platform Project

This Visual Studio / MSBuild project is used to deploy code and configuration
to the main Sitecore platform roles, known as Content Management and
Content Delivery. (This sample uses the XP0 container topology and thus only has a
Standalone `cm`.)

To deploy configuration, assemblies, and content from this project into your running Docker
environment, run a Publish of it from Visual Studio. To debug, you can attach to
the `w3wp` process within the `cm` container.