# Website Deployment Module

The primary purpose of this module is managing the build/publish of the
solution to a Sitecore instance using Helix Publishing Pipeline. It also
contains a copy of the `Web.config` for the target Sitecore version, which
can be transformed by other modules.

This module exists outside the traditional Helix layers, as it does not
relate to any given business domain and exists purely for the purpose of
assisting deployment.