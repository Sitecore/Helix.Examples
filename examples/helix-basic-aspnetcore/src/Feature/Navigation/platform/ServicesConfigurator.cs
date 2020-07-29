using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;

namespace BasicCompany.Feature.Navigation
{
    public class ServicesConfigurator : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<Services.IHeaderBuilder, Services.HeaderBuilder>();
            serviceCollection.AddTransient<Services.INavigationRootResolver, Services.NavigationRootResolver>();
        }
    }
}