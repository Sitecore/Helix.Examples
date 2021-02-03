# Serialized Sitecore Items

This path contains serialized Sitecore content items for this example. The
serialized paths are configured in `*.module.json` files in the parent directory.

* `InitItems.module.json` configures items which this template needs to
  push before deploying JSS items using `jss deploy`.
* `BasicCompany.module.json` contains developer-owned configuration items
  which are created by the JSS Styleguide sample.
* `BasicCompany-Content.module.json` contains content items which are
  created by the JSS Styleguide sample. It's a good practice to put content
  into a separate module, so it can be excluded from packaging and deployment.

You may wish to reorganize these items as appropriate for your solution, and/or
configure them in Helix-style modules.

See Sitecore Content Serialization documentation for more information.