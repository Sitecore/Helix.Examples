using BasicCompany.Feature.Navigation.Models;
using Sitecore.AspNet.RenderingEngine.Configuration;
using Sitecore.AspNet.RenderingEngine.Extensions;

namespace BasicCompany.Feature.Navigation.Extensions
{
    public static class RenderingEngineOptionsExtensions
    {
        public static RenderingEngineOptions AddFeatureNavigation(this RenderingEngineOptions options)
        {
            options.AddModelBoundView<Header>("Header")
                   .AddModelBoundView<Footer>("Footer");
            return options;
        }
    }
}
