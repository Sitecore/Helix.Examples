using Sitecore.LayoutService.Configuration;
using Sitecore.Mvc.Presentation;
using BasicCompany.Feature.Navigation.Services;

namespace BasicCompany.Feature.Navigation.LayoutService
{
    public class FooterContentsResolver : Sitecore.LayoutService.ItemRendering.ContentsResolvers.RenderingContentsResolver
    {
        protected readonly INavigationRootResolver RootResolver;

        public FooterContentsResolver(INavigationRootResolver rootResolver, IHeaderBuilder headerBuilder)
        {
            RootResolver = rootResolver;
        }

        public override object ResolveContents(Rendering rendering, IRenderingConfiguration renderingConfig)
        {
            var root = RootResolver.GetNavigationRoot(this.GetContextItem(rendering, renderingConfig));
            return new
            {
                FooterText = root[Templates.NavigationRoot.Fields.FooterCopyright]
            };
        }
    }
}