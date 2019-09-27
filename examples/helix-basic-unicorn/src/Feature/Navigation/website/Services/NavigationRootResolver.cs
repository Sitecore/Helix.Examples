using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.Navigation.Services
{
    public class NavigationRootResolver : INavigationRootResolver
    {
        public Item GetNavigationRoot(Item contextItem)
        {
            if (contextItem == null)
            {
                return null;
            }
            return contextItem.DescendsFrom(Templates.NavigationRoot.Id)
                ? contextItem
                : contextItem.Axes.GetAncestors().LastOrDefault(x => x.DescendsFrom(Templates.NavigationRoot.Id));
        }
    }
}