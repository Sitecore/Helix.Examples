using System.Linq;
using BasicCompany.Feature.Navigation.Data;
using Sitecore.Data.Items;
using Xunit;

namespace BasicCompany.Feature.Navigation.Tests.Data
{
    public class NavigationRootTest
    {
        [Fact]
        public void GetNavigationItemsWithoutChildrenReturnsEmpty()
        {
            var inner = ItemMock.NewObject();
            var sut = new NavigationRoot(inner);
            Assert.Empty(sut.GetNavigationItems());
        }

        [Fact]
        public void GetNavigationItemsWithValidChildrenReturnsList()
        {
            var expected = new[]
            {
                ItemMock.New().DescendsFrom(Templates.NavigationItem.Id).Object,
                ItemMock.New().DescendsFrom(Templates.NavigationItem.Id).Object
            };
            var inner = ItemMock.New().WithChildren(expected);
            var sut = new NavigationRoot(inner.Object);
            var actual = sut.GetNavigationItems();
            Assert.True(expected.SequenceEqual(actual));
        }

        [Fact]
        public void GetNavigationItemsFiltersByTemplate()
        {
            var expected = ItemMock.New("expected").DescendsFrom(Templates.NavigationItem.Id).Object;
            var invalidChild = ItemMock.New("invalid").Object;
            var inner = ItemMock.New().WithChildren(new[] { expected, invalidChild });
            var sut = new NavigationRoot(inner.Object);
            var actual = sut.GetNavigationItems();
            Assert.Same(expected, actual.Single());
        }

        [Fact]
        public void CastToItemForNullReturnsNull()
        {
            Item actual = (NavigationRoot)null;
            Assert.Null(actual);
        }

        [Fact]
        public void CastToItemForNullReturnsInnerItem()
        {
            var expected = ItemMock.NewObject();
            var sut = new NavigationRoot(expected);
            Item actual = sut;
            Assert.Same(expected, actual);
        }
    }
}