using Sitecore.Data.Items;

namespace BasicCompany.Feature.Navigation.Services
{
    public interface INavigationRootResolver
    {
        Item GetNavigationRoot(Item contextItem);
    }
}
