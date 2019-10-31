using System.Linq;
using BasicCompany.Feature.Navigation.Data;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.Navigation.Services
{
    public class NavigationRootResolver : INavigationRootResolver
    {
        public NavigationRoot GetNavigationRoot(Item contextItem)
        {
            if (contextItem == null)
            {
                return null;
            }

            var root = contextItem.DescendsFrom(Templates.NavigationRoot.Id)
                ? contextItem
                : contextItem.Axes.GetAncestors().LastOrDefault(x => x.DescendsFrom(Templates.NavigationRoot.Id));

            return root != null ? new NavigationRoot(root) : null;
        }
    }
}