using BasicCompany.Feature.Navigation.Services;
using Xunit;

namespace BasicCompany.Feature.Navigation.Tests
{
    public class NavigationRootResolverTest
    {
        [Fact]
        public void GetNavigationRootForNullReturnsNull()
        {
            var sut = new NavigationRootResolver();
            var actual = sut.GetNavigationRoot(null);
            Assert.Null(actual);
        }

        [Fact]
        public void GetNavigationRootForMissingRootReturnsNull()
        {
            var item = ItemMock.New().Object;
            var sut = new NavigationRootResolver();
            var actual = sut.GetNavigationRoot(item);
            Assert.Null(actual);
        }

        [Fact]
        public void GetNavigationRootForRootReturnsRoot()
        {
            var expected = ItemMock.New().DescendsFrom(Templates.NavigationRoot.Id).Object;
            var sut = new NavigationRootResolver();
            var actual = sut.GetNavigationRoot(expected);
            Assert.Same(expected, actual);
        }

        [Fact]
        public void GetNavigationRootForChildReturnsRoot()
        {
            var expected = ItemMock.New().DescendsFrom(Templates.NavigationRoot.Id).Object;
            var child = ItemMock.New().WithAncestors(new[] { expected }).Object;
            var sut = new NavigationRootResolver();
            var actual = sut.GetNavigationRoot(child);
            Assert.Same(expected, actual);
        }

        [Fact]
        public void GetNavigationRootReturnsLastRoot()
        {
            var someRoot = ItemMock.New().DescendsFrom(Templates.NavigationRoot.Id).Object;
            var expected = ItemMock.New().DescendsFrom(Templates.NavigationRoot.Id).Object;
            var child = ItemMock.New().WithAncestors(new[] { someRoot, expected }).Object;
            var sut = new NavigationRootResolver();
            var actual = sut.GetNavigationRoot(child);
            Assert.Same(expected, actual);
        }
    }
}