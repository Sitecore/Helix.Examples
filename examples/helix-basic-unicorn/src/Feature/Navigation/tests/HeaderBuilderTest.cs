using System.Collections.Generic;
using System.Linq;
using BasicCompany.Feature.Navigation.Data;
using BasicCompany.Feature.Navigation.Services;
using Moq;
using Sitecore.Abstractions;
using Sitecore.Data.Items;
using Xunit;

namespace BasicCompany.Feature.Navigation.Tests
{
    public class HeaderBuilderTest
    {
        [Fact]
        public void GetHeaderWithNullRootReturnsEmptyProps()
        {
            var context = ItemMock.NewObject();
            var linkManager = Mock.Of<BaseLinkManager>();
            var rootResolver = Mock.Of<INavigationRootResolver>();
            var sut = new HeaderBuilder(linkManager, rootResolver);
            var actual = sut.GetHeader(context);
            Assert.Null(actual.HomeItem);
            Assert.Null(actual.HomeUrl);
            Assert.Null(actual.NavigationItems);
        }

        [Fact]
        public void GetHeaderSetsHomeItem()
        {
            var context = ItemMock.NewObject();
            var linkManager = Mock.Of<BaseLinkManager>();
            var navigationRoot = new Mock<NavigationRoot>(context).Object;
            var rootResolver = Mock.Of<INavigationRootResolver>(x =>
                x.GetNavigationRoot(context) == navigationRoot);
            var sut = new HeaderBuilder(linkManager, rootResolver);
            var actual = sut.GetHeader(context);
            Assert.Same(context, actual.HomeItem);
        }

        [Fact]
        public void GetHeaderInjectsHomeItemIntoNavigationItems()
        {
            var context = ItemMock.NewObject();
            var item1 = ItemMock.NewObject();
            var item2 = ItemMock.NewObject();
            var expected = new List<Item> { context, item1, item2 };
            var navigationRoot = new Mock<NavigationRoot>(context);
            navigationRoot.Setup(x => x.GetNavigationItems()).Returns(new[] { item1, item2 });
            var linkManager = Mock.Of<BaseLinkManager>();
            var rootResolver = Mock.Of<INavigationRootResolver>(x =>
                x.GetNavigationRoot(context) == navigationRoot.Object);
            var sut = new HeaderBuilder(linkManager, rootResolver);
            var actual = sut.GetHeader(context).NavigationItems.Select(x => x.Item);
            Assert.True(expected.SequenceEqual(actual));
        }

        [Fact]
        public void GetHeaderSetsHomeUrl()
        {
            var context = ItemMock.NewObject();
            const string expected = "http://mysite";
            var linkManager = Mock.Of<BaseLinkManager>(x =>
                x.GetItemUrl(context) == expected);
            var navigationRoot = new Mock<NavigationRoot>(context).Object;
            var rootResolver = Mock.Of<INavigationRootResolver>(x =>
                x.GetNavigationRoot(context) == navigationRoot);
            var sut = new HeaderBuilder(linkManager, rootResolver);
            var actual = sut.GetHeader(context);
            Assert.Same(expected, actual.HomeUrl);
        }

        [Fact]
        public void GetHeaderSetsNavigationItemsUrl()
        {
            var context = ItemMock.NewObject();
            const string expected1 = "http://mysite/page1";
            const string expected2 = "http://mysite/page2";
            var item1 = ItemMock.NewObject();
            var item2 = ItemMock.NewObject();
            var navigationRoot = new Mock<NavigationRoot>(context);
            navigationRoot.Setup(x => x.GetNavigationItems()).Returns(new[] { item1, item2 });
            var linkManager = Mock.Of<BaseLinkManager>(x =>
                x.GetItemUrl(item1) == expected1 &&
                x.GetItemUrl(item2) == expected2);
            var rootResolver = Mock.Of<INavigationRootResolver>(x =>
                x.GetNavigationRoot(context) == navigationRoot.Object);
            var sut = new HeaderBuilder(linkManager, rootResolver);
            var actual = sut.GetHeader(context);
            Assert.Same(expected1, actual.NavigationItems[1].Url);
            Assert.Same(expected2, actual.NavigationItems[2].Url);
        }

        [Fact]
        public void GetHeaderSetsNavigationRootAsActive()
        {
            var context = ItemMock.NewObject();
            var navigationRoot = new Mock<NavigationRoot>(context);
            var linkManager = Mock.Of<BaseLinkManager>();
            var rootResolver = Mock.Of<INavigationRootResolver>(x =>
                x.GetNavigationRoot(context) == navigationRoot.Object);
            var sut = new HeaderBuilder(linkManager, rootResolver);
            var actual = sut.GetHeader(context);
            Assert.True(actual.NavigationItems.First().IsActive);
        }

        [Fact]
        public void GetHeaderWithActiveSubItemSetsSubItemAsActive()
        {
            var root = ItemMock.NewObject("root");
            var subItem = ItemMock.New("sub-item");
            subItem.Setup(x => x.Paths.LongID).Returns(root.Paths.LongID + subItem.Object.Paths.LongID);
            var navigationRoot = new Mock<NavigationRoot>(root);
            navigationRoot.Setup(x => x.GetNavigationItems()).Returns(new[] { subItem.Object });
            var linkManager = Mock.Of<BaseLinkManager>();
            var rootResolver = Mock.Of<INavigationRootResolver>(x =>
                x.GetNavigationRoot(subItem.Object) == navigationRoot.Object);
            var sut = new HeaderBuilder(linkManager, rootResolver);
            var actual = sut.GetHeader(subItem.Object);
            Assert.True(actual.NavigationItems[1].IsActive);
        }

        [Fact]
        public void GetHeaderWithActiveSubItemSetsNavigationRootAsActive()
        {
            var root = ItemMock.NewObject("root");
            var subItem = ItemMock.New("sub-item");
            subItem.Setup(x => x.Paths.LongID).Returns(root.Paths.LongID + subItem.Object.Paths.LongID);
            var navigationRoot = new Mock<NavigationRoot>(root);
            navigationRoot.Setup(x => x.GetNavigationItems()).Returns(new[] { subItem.Object });
            var linkManager = Mock.Of<BaseLinkManager>();
            var rootResolver = Mock.Of<INavigationRootResolver>(x =>
                x.GetNavigationRoot(subItem.Object) == navigationRoot.Object);
            var sut = new HeaderBuilder(linkManager, rootResolver);
            var actual = sut.GetHeader(subItem.Object);
            Assert.True(actual.NavigationItems[0].IsActive);
        }
    }
}