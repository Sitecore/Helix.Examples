using System.Linq;
using BasicCompany.Feature.Products.Services;
using Moq;
using Moq.Protected;
using Sitecore.Abstractions;
using Sitecore.ContentSearch;
using Sitecore.Data;
using Sitecore.Data.Items;
using Sitecore.Globalization;
using Xunit;
using Version = Sitecore.Data.Version;

namespace BasicCompany.Feature.Products.Tests
{
    public class ProductRepositoryTests
    {
        [Fact]
        public void FiltersOnPathAndTemplate()
        {
            // Mock the database
            var db = Mock.Of<Database>();

            // Mock the parent item
            var parentId = ID.NewID;
            var parentDef = new ItemDefinition(parentId, "parent", Templates.Product.Id, ID.Null);
            var parentData = new ItemData(parentDef, Language.Parse("en"), Version.Parse(1), new FieldList());
            var parent = new Mock<Item>(parentId, parentData, db);

            // Mock the Sitecore services
            var factoryMock = new Mock<BaseFactory>();
            factoryMock.Setup(x => x.GetDatabase(It.IsAny<string>())).Returns(db);
            var factory = factoryMock.Object;
            var itemManager = Mock.Of<BaseItemManager>();

            // Mock search context, so we are testing LINQ to Objects instead of LINQ to Sitecore
            var itemUri = new ItemUri("sitecore://master/{11111111-1111-1111-1111-111111111111}?lang=en&ver=1");
            var mockSearchContext = new Mock<IProviderSearchContext>();
            mockSearchContext.Setup(x => x.GetQueryable<ProductSearchQuery>())
                .Returns(new[]
                {
                    // Matches Path and Template
                    new ProductSearchQuery
                    {
                        UniqueId = itemUri,
                        Templates = new[] {Templates.Product.Id },
                        Paths = new[] { parentId }
                    },
                    // Matches Path and Template
                    new ProductSearchQuery
                    {
                        UniqueId = itemUri,
                        Templates = new[] { ID.NewID, Templates.Product.Id, ID.NewID },
                        Paths = new[] { ID.NewID, parentId, ID.NewID }
                    },
                    // Matches Template Only
                    new ProductSearchQuery
                    {
                        UniqueId = itemUri,
                        Templates = new[] { Templates.Product.Id },
                        Paths = new[] { ID.NewID }
                    },
                    // Matches Path Only
                    new ProductSearchQuery
                    {
                        UniqueId = itemUri,
                        Templates = new[] { ID.NewID },
                        Paths = new[] { parentId }
                    }
                }.AsQueryable());

            // Use Moq.Protected to ensure our test object uses the mock search context
            var mockRepo = new Mock<ProductRepository>(factory, itemManager);
            mockRepo.Protected()
                .Setup<IProviderSearchContext>("GetSearchContext", ItExpr.IsAny<Item>())
                .Returns(mockSearchContext.Object);

            // Act
            var result = mockRepo.Object.GetProducts(parent.Object).ToList();

            // If the tested class is filtering appropriately, we should get predictible results
            Assert.Equal(2, result.Count);
        }
    }
}
