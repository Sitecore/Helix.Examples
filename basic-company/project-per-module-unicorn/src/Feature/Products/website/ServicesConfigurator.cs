using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BasicCompany.Feature.Products
{
    public class ServicesConfigurator : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<Controllers.ProductsController>();
            serviceCollection.AddTransient<Services.IProductRepository, Services.ProductRepository>();
        }
    }
}