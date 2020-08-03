using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using BasicCompany.Feature.Navigation.Models;
using Sitecore.Data.Items;
using Sitecore.Abstractions;

namespace BasicCompany.Feature.Navigation.Services
{
    public class HeaderBuilder : IHeaderBuilder
    {
        protected readonly INavigationRootResolver RootResolver;
        protected readonly BaseLinkManager LinkManager;

        public HeaderBuilder(BaseLinkManager linkManager, INavigationRootResolver rootResolver)
        {
            Debug.Assert(linkManager != null);
            Debug.Assert(rootResolver != null);
            LinkManager = linkManager;
            RootResolver = rootResolver;
        }

        public Header GetHeader(Item contextItem)
        {
            Debug.Assert(contextItem != null);
            var navigationRoot = RootResolver.GetNavigationRoot(contextItem);
            if (navigationRoot == null)
            {
                return new Header();
            }

            return new Header
            {
                HomeItem = navigationRoot,
                HomeUrl = LinkManager.GetItemUrl(navigationRoot),
                NavigationItems = GetNavigationItems(navigationRoot, contextItem)
            };
        }

        private IList<NavigationItem> GetNavigationItems(Item navigationRoot, Item contextItem)
        {
            // Collect home/root item and its children which are navigable
            var items = new List<Item> { navigationRoot };
            items.AddRange(navigationRoot.Children.Where(item => item.DescendsFrom(Templates.NavigationItem.Id)));

            // Initialize with home/root page
            var navigationItems = items.Select(item => new NavigationItem
            {
                Item = item,
                Url = LinkManager.GetItemUrl(item),
                IsActive = item.ID == navigationRoot.ID ?
                    item.ID == contextItem.ID // must be exact match to highlight home
                    : contextItem.Paths.LongID.StartsWith(item.Paths.LongID)
            }).ToList();

            return navigationItems;
        }
    }
}