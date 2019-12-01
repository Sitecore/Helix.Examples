using BasicCompany.Feature.Navigation.Controllers;
using BasicCompany.Feature.Navigation.Services;
using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;

namespace BasicCompany.Feature.Navigation
{
    public class ServicesConfigurator : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<NavigationController>();
            serviceCollection.AddTransient<IHeaderBuilder, HeaderBuilder>();
            serviceCollection.AddTransient<INavigationRootResolver, NavigationRootResolver>();
        }
    }
}