using BasicCompany.Feature.Services.Models;
using Sitecore.AspNet.RenderingEngine.Configuration;
using Sitecore.AspNet.RenderingEngine.Extensions;

namespace BasicCompany.Feature.Products.Extensions
{
    public static class RenderingEngineOptionsExtensions
    {
        public static RenderingEngineOptions AddFeatureServices(this RenderingEngineOptions options)
        {
            options
                .AddPartialView("TestimonialContainer")
                .AddModelBoundView<Testimonial>("Testimonial");
            return options;
        }
    }
}
