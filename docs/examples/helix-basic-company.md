---
layout: page
hide_hero: true
---
# Helix Basic Company

This is a simple, single-site example of Sitecore Helix solution architecture.
It is intentionally small / low-functionality so that it can demonstrate the
basics of modular architecture without being overwhemling. This also allows it
to be implemented with multiple toolsets / patterns without creating significant
maintenance overhead for the examples themselves.

## Business Context

The fictional Helix Basic Company is undergoing the first phase of their Sitecore XP
implementation. The initial site rollout is only to include a basic product catalog,
and service testimonials. In the future, they plan to expand their site to include
company news, a customer portal, and search functionality. Thus the solution architect
determined that Sitecore Helix practices would be appropriate despite the simplicity of
the site.

> *The point being, this site is exceedingly simple, so without that business context,
it likely would not merit application of Sitecore Helix practices, or perhaps would be
implemented as a single Project-layer module.*

## Implementations

### [Helix Basic Company - ASP.NET Core and Sitecore Content Serialization](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-aspnetcore)

This is a [ASP.NET Core Rendering SDK](https://doc.sitecore.com/developers/100/developer-tools/en/sitecore-headless-development.html) and [Sitecore Content Serialization](https://doc.sitecore.com/developers/100/developer-tools/en/sitecore-content-serialization.html) based implementation of Helix Basic Company.
* The site is rendered in an independently-running rendering host, built in ASP.NET Core. Some modules contain code for both the Rendering Host and the "Platform" CM/CD roles.
  * Projects which deploy to CM/CD use "platform" in their naming instead of "website" due to the use of a headless architecture.
* Items are serialized using the Sitecore CLI.
* [Helix Publishing Pipeline](https://github.com/richardszalay/helix-publishing-pipeline) is used for building and deploying code for CM/CD, and is configured to auto-deploy on build.
* The Rendering Host projects do not need Helix Publishing Pipeline, because ASP.NET Core / SDK-style projects support sharing content assets.

### [Helix Basic Company - Next.js and Sitecore Content Serialization](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-nextjs)

This is a [Sitecore JSS / Next.js](https://jss.sitecore.com/docs/nextjs/introduction/why-nextjs) and [Sitecore Content Serialization](https://doc.sitecore.com/developers/100/developer-tools/en/sitecore-content-serialization.html) based implementation of Helix Basic Company.
* The site is rendered in an independently-running rendering host, built with Next.js.
* The JavaScript/Next.js solution is intentionally kept in the Project layer, in its entirety, without using Helix semantics, as to not require Sitecore solution architecture in front-end code.
* The JSS project is configured for a _Sitecore-first_ workflow. It uses serialized items and not JSS _code-first_ deployment.
  * For mocking of Sitecore data, it uses [Storybook](https://storybook.js.org/) instead.
* This solution avoids the need for back-end Sitecore code through use of GraphQL to obtain additional data. Thus the Visual Studio solution is rather sparse. It could be argued that this could be further simplified in a real-world solution.
* Items are serialized using the Sitecore CLI.
* [Helix Publishing Pipeline](https://github.com/richardszalay/helix-publishing-pipeline) is used for building and deploying code for CM/CD, and is configured to auto-deploy on build.

### [Helix Basic Company - TDS](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-tds)

This is a [Sitecore TDS](https://www.teamdevelopmentforsitecore.com/TDS-Classic)-based
implementation of Helix Basic Company. It utilizes Sitecore TDS both for
serialization and builds.
* Modules containing items include TDS projects for the *master* and *core* databases as needed.
* To avoid the need for a deployment-only TDS project on modules which do not have items, a
single deployment-only *Website* project handles all file deployment.

### [Helix Basic Company - TDS Consolidated](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-tds-consolidated)

This version of Helix Basic Company consolidates the entire solution into a single
Visual Studio web project and uses Sitecore TDS validation and
[FxCop rules](https://www.hhog.com/sitecore-helix-fxcop-rules) to enforce references /
dependencies.
* This is an **extreme** example of consolidated projects in a Sitecore Helix solution
architecture. For many implementations, this could eventually turn into technical debt
and make it difficult to track dependencies and/or to track all the code, configuration,
and items for a particular module. However Basic Company is small and, in this case,
the solution architect has chosen to start simply and potentially pay that technical debt later.
* Note that as a result of this organization, some items which do not easily organize into
Sitecore Helix modules in the content tree are of uncertain ownership
(e.g. the *BasicCompany Site Root* insert rule).

### [Helix Basic Company - Unicorn](https://github.com/Sitecore/Helix.Examples/tree/master/examples/helix-basic-unicorn)

The [Unicorn](https://github.com/SitecoreUnicorn/Unicorn)-based implementation of Helix
Basic Company. It uses Unicorn for serialization, and
[Helix Publishing Pipeline](https://github.com/richardszalay/helix-publishing-pipeline)
for builds.
* A base Unicorn configuration is included in the *Serialization* Foundation module
which takes advantage of Unicorn's `$(layer)` and `$(module)` variables, but is otherwise
fairly simple and leaves each module to configure its own predicates and dependencies.
* Helix Publishing Pipeline is configured to auto-deploy on build.