using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;

namespace BasicCompany.Feature.Products
{
    public class ServicesConfigurator : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<BasicCompany.Feature.Products.Controllers.ProductsController>();
            serviceCollection.AddTransient<BasicCompany.Feature.Products.Services.IProductRepository, BasicCompany.Feature.Products.Services.ProductRepository>();
        }
    }
}