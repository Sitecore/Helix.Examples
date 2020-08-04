using System.Diagnostics;
using System.Linq;
using Sitecore.LayoutService.Configuration;
using Sitecore.Mvc.Presentation;
using BasicCompany.Feature.Navigation.Services;

namespace BasicCompany.Feature.Navigation.LayoutService
{
    public class HeaderContentsResolver : Sitecore.LayoutService.ItemRendering.ContentsResolvers.RenderingContentsResolver
    {
        protected readonly IHeaderBuilder HeaderBuilder;

        public HeaderContentsResolver(INavigationRootResolver rootResolver, IHeaderBuilder headerBuilder)
        {
            Debug.Assert(rootResolver != null);
            Debug.Assert(headerBuilder != null);
            HeaderBuilder = headerBuilder;
        }

        public override object ResolveContents(Rendering rendering, IRenderingConfiguration renderingConfig)
        {
            var header = HeaderBuilder.GetHeader(this.GetContextItem(rendering, renderingConfig));
            var contents = new
            {
                logoLink = this.ProcessItem(header.HomeItem, rendering, renderingConfig),
                navItems = header.NavigationItems.Select(x => new
                {
                    url = x.Url,
                    isActive = x.IsActive,
                    title = x.Item[Templates.NavigationItem.Fields.NavigationTitle]
                })
            };
            return contents;
        }
    }
}