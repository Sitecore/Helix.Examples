---
layout: page
hide_hero: true
---
# About the Examples

## Helix Basic Company

This is a simple, single-site example of Sitecore Helix solution architecture.
It is intentionally small / low-functionality so that it can demonstrate the
basics of modular architecture without being overwhemling. This also allows it
to be implemented with multiple toolsets / patterns without creating significant
maintenance overhead.

### Helix Basic Company - TDS

The [Sitecore TDS](https://www.teamdevelopmentforsitecore.com/TDS-Classic)-based
implementation of Helix Basic Company. It utilizes Sitecore TDS both for
serialization and builds.

### Helix Basic Company - TDS Consolidated (Forthcoming)

This version of Helix Basic Company consolidates the *Feature* layer into a single
Visual Studio project and uses Sitecore TDS validation and
[FxCop rules](https://www.hhog.com/sitecore-helix-fxcop-rules) to enforce references /
dependencies.

### Helix Basic Company - Unicorn

The [Unicorn](https://github.com/SitecoreUnicorn/Unicorn)-based implementation of Helix
Basic Company. It uses Unicorn for serialization, and
[Helix Publishing Pipeline](https://github.com/richardszalay/helix-publishing-pipeline)
for builds.

## Helix Franchise Company (Forthcoming)

This example will demonstrate a "franchise" site architecture following
Sitecore Helix practices.

* Multi-site, with same renderings but differing content and CSS
* Simple header and footer
* 3 franchises
* Different workflows per site

## Helix Corporation (Forthcoming)

This example will demonstrate a more complex multi-site architecture and
functionality following Sitecore Helix practices.

* Multi-site, with sufficiently different front-end to necessitate different markup per site (use MVC areas?)
* Include some site-specific renderings
* Per-site languages w/ translation
* Integrated, Helix-patterned client code?
* Site-specific datasource locations
* Dictionary use
* Feature-to-Feature communication examples (dependency inversion approaches)
* Reference for other recipes / how-to's