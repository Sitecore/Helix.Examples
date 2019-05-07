using System;
using System.Linq;
using BasicCompany.Feature.Navigation.Services;
using Moq;
using Sitecore.Abstractions;
using Sitecore.Data;
using Sitecore.Data.Items;
using Sitecore.FakeDb;
using Xunit;

namespace BasicCompany.Feature.Navigation.Tests
{
    public class HeaderBuilderTests : IDisposable
    {
        private Db _db;
        private INavigationRootResolver _rootResolver;

        public HeaderBuilderTests()
        {
            var homeTemplate = ID.NewID;
            var pageTemplate = ID.NewID;
            _db = new Db
            {
                new DbTemplate(Templates.NavigationRoot.Id),
                new DbTemplate(Templates.NavigationItem.Id),
                new DbTemplate(homeTemplate)
                {
                    BaseIDs = new[] {Templates.NavigationRoot.Id, Templates.NavigationItem.Id}
                },
                new DbTemplate(pageTemplate)
                {
                    BaseIDs = new[] {Templates.NavigationItem.Id}
                },
                new DbItem("Home", ID.NewID, homeTemplate)
                {
                    new DbItem("Child1", ID.NewID, pageTemplate),
                    new DbItem("Child2", ID.NewID, pageTemplate)
                    {
                        new DbItem("Grandchild", ID.NewID, pageTemplate)
                    }
                }
            };
            var rootResolverMock = new Mock<INavigationRootResolver>();
            rootResolverMock.Setup(x => x.GetNavigationRoot(It.IsAny<Item>()))
                .Returns(_db.GetItem("/sitecore/content/Home"));
            _rootResolver = rootResolverMock.Object;
        }

        public void Dispose()
        {
            _db?.Dispose();
            _db = null;
            _rootResolver = null;
        }

        [Fact]
        public void SetsNavigationRootAsHomeItem()
        {
            var item = _db.GetItem("/sitecore/content/Home/Child1");
            var linkManager = new Mock<BaseLinkManager>();
            var headerBuilder = new HeaderBuilder(linkManager.Object, _rootResolver);

            var header = headerBuilder.GetHeader(item);

            var expectedItem = _rootResolver.GetNavigationRoot(item);
            Assert.Equal(expectedItem, header.HomeItem);
        }

        [Fact]
        public void SetsHomeUrlFromLinkManager()
        {
            var url = "/";
            var item = _db.GetItem("/sitecore/content/Home/Child1");
            var linkManager = new Mock<BaseLinkManager>();
            var rootItem = _rootResolver.GetNavigationRoot(item);
            linkManager.Setup(x => x.GetItemUrl(It.Is<Item>(y => y == rootItem))).Returns(url);
            var headerBuilder = new HeaderBuilder(linkManager.Object, _rootResolver);

            var header = headerBuilder.GetHeader(item);

            Assert.Equal(url, header.HomeUrl);
        }

        [Fact]
        public void NavigationAddsHomeFirst()
        {
            var item = _db.GetItem("/sitecore/content/Home/Child1");
            var linkManager = new Mock<BaseLinkManager>();
            var headerBuilder = new HeaderBuilder(linkManager.Object, _rootResolver);

            var header = headerBuilder.GetHeader(item);

            var expectedItem = _rootResolver.GetNavigationRoot(item);
            Assert.Equal(expectedItem, header.NavigationItems?.FirstOrDefault()?.Item);
        }

        [Fact]
        public void NavigationAddsNavigationItemsSecond()
        {
            var item = _db.GetItem("/sitecore/content/Home/Child1");
            var linkManager = new Mock<BaseLinkManager>();
            var headerBuilder = new HeaderBuilder(linkManager.Object, _rootResolver);

            var header = headerBuilder.GetHeader(item);

            var navItems = header.NavigationItems;
            Assert.NotNull(navItems);
            Assert.Equal(3, navItems.Count);
            Assert.Equal("Child1", navItems[1].Item.Name);
            Assert.Equal("Child2", navItems[2].Item.Name);
        }

        [Theory]
        [InlineData("/sitecore/content/Home")]
        [InlineData("/sitecore/content/Home/Child1")]
        [InlineData("/sitecore/content/Home/Child2")]
        public void NavigationMarksContextItemAsActive(string path)
        {
            var item = _db.GetItem(path);
            var linkManager = new Mock<BaseLinkManager>();
            var headerBuilder = new HeaderBuilder(linkManager.Object, _rootResolver);

            var header = headerBuilder.GetHeader(item);

            var navItems = header.NavigationItems;
            Assert.Equal(1, navItems.Count(x => x.IsActive));
            Assert.Equal(path, navItems.Single(x => x.IsActive).Item.Paths.FullPath);
        }

        [Fact]
        public void NavigationMarksChildItemAsActiveForGrandchild()
        {
            var item = _db.GetItem("/sitecore/content/Home/Child2/Grandchild");
            var linkManager = new Mock<BaseLinkManager>();
            var headerBuilder = new HeaderBuilder(linkManager.Object, _rootResolver);

            var header = headerBuilder.GetHeader(item);

            var navItems = header.NavigationItems;
            Assert.Equal(1, navItems.Count(x => x.IsActive));
            Assert.Equal("/sitecore/content/Home/Child2", navItems.Single(x => x.IsActive).Item.Paths.FullPath);
        }

        [Fact]
        public void NavigationSetsUrlFromLinkManager()
        {
            var url = "/something";
            var item = _db.GetItem("/sitecore/content/Home");
            var linkManager = new Mock<BaseLinkManager>();
            linkManager.Setup(x => x.GetItemUrl(It.IsAny<Item>())).Returns(url);
            var headerBuilder = new HeaderBuilder(linkManager.Object, _rootResolver);

            var header = headerBuilder.GetHeader(item);

            var navItems = header.NavigationItems;
            Assert.All(navItems, x => Assert.Equal(url, x.Url));
        }
    }
}
