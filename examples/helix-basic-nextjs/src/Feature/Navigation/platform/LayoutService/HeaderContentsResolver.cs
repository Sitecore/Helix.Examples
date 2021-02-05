using System.Diagnostics;
using System.Linq;
using Sitecore.LayoutService.Configuration;
using Sitecore.Mvc.Presentation;
using BasicCompany.Feature.Navigation.Services;

namespace BasicCompany.Feature.Navigation.LayoutService
{
    public class HeaderContentsResolver : Sitecore.LayoutService.ItemRendering.ContentsResolvers.RenderingContentsResolver
    {
        protected readonly INavigationRootResolver RootResolver;

        public HeaderContentsResolver(INavigationRootResolver rootResolver)
        {
            Debug.Assert(rootResolver != null);
            RootResolver = rootResolver;
        }

        public override object ResolveContents(Rendering rendering, IRenderingConfiguration renderingConfig)
        {
            var root = RootResolver.GetNavigationRoot(this.GetContextItem(rendering, renderingConfig));
            var contents = new
            {
                rootId = root.ID.Guid.ToString("N")
            };
            return contents;
        }
    }
}