using System.Collections.Generic;
using System.Linq;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.Navigation.Data
{
    public class NavigationRoot : CustomItem
    {
        public NavigationRoot(Item innerItem)
            : base(innerItem)
        {
        }

        public IEnumerable<Item> GetNavigationItems()
        {
            return InnerItem.Children.Where(i =>
                i.DescendsFrom(Templates.NavigationItem.Id));
        }

        public static implicit operator Item(NavigationRoot navigationRoot)
        {
            return navigationRoot?.InnerItem;
        }
    }
}