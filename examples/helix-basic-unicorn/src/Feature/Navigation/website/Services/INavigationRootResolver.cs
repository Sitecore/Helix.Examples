using BasicCompany.Feature.Navigation.Data;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.Navigation.Services
{
    public interface INavigationRootResolver
    {
        NavigationRoot GetNavigationRoot(Item contextItem);
    }
}
