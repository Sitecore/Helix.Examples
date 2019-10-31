using System;
using BasicCompany.Feature.Navigation.Data;
using BasicCompany.Feature.Navigation.Services;
using Moq;
using Sitecore.Abstractions;
using Xunit;

namespace BasicCompany.Feature.Navigation.Tests
{
    public class HeaderBuilderTest
    {
        [Fact]
        public void GetHeaderWithNullThrows()
        {
            var linkManager = Mock.Of<BaseLinkManager>();
            var rootResolver = Mock.Of<INavigationRootResolver>();
            var sut = new HeaderBuilder(linkManager, rootResolver);
            Assert.Throws<ArgumentNullException>(() =>
                 sut.GetHeader(null));
        }

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
    }
}