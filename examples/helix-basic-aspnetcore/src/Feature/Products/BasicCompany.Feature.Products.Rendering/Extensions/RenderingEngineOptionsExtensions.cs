using BasicCompany.Feature.Products.Models;
using Sitecore.AspNet.RenderingEngine.Configuration;
using Sitecore.AspNet.RenderingEngine.Extensions;

namespace BasicCompany.Feature.Products.Extensions
{
    public static class RenderingEngineOptionsExtensions
    {
        public static RenderingEngineOptions AddFeatureProducts(this RenderingEngineOptions options)
        {
            options.AddModelBoundView<ProductList>("ProductList");
            return options;
        }
    }
}
