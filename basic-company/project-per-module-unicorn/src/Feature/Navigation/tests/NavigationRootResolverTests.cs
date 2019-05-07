using System;
using BasicCompany.Feature.Navigation.Services;
using Sitecore.Data;
using Sitecore.Data.Items;
using Sitecore.FakeDb;
using Xunit;

namespace BasicCompany.Feature.Navigation.Tests
{
    public class NavigationRootResolverTests : IDisposable
    {
        private Db _db;
        private Item _rootItem;

        public NavigationRootResolverTests()
        {
            var homeTemplate = ID.NewID;
            _db = new Db
            {
                new DbTemplate(Templates.NavigationRoot.Id),
                new DbTemplate(homeTemplate)
                {
                    BaseIDs = new[] { Templates.NavigationRoot.Id }
                },
                new DbItem("Home", ID.NewID, homeTemplate)
                {
                    new DbItem("Child")
                    {
                        new DbItem("Grandchild")
                    }
                }
            };
            _rootItem = _db.GetItem("/sitecore/content/Home");
        }

        public void Dispose()
        {
            _db?.Dispose();
            _db = null;
        }

        [Fact]
        public void ResolvesWhenContextItemIsRoot()
        {
            var contextItem = _db.GetItem("/sitecore/content/Home");
            var rootResolver = new NavigationRootResolver();

            var resolvedItem = rootResolver.GetNavigationRoot(contextItem);

            Assert.Equal(_rootItem.ID, resolvedItem.ID);
        }

        [Fact]
        public void ResolvesWhenContextItemIsChild()
        {
            var contextItem = _db.GetItem("/sitecore/content/Home/Child");
            var rootResolver = new NavigationRootResolver();

            var resolvedItem = rootResolver.GetNavigationRoot(contextItem);

            Assert.Equal(_rootItem.ID, resolvedItem.ID);
        }

        [Fact]
        public void ResolvesWhenContextItemIsGrandchild()
        {
            var contextItem = _db.GetItem("/sitecore/content/Home/Child/Grandchild");
            var rootResolver = new NavigationRootResolver();

            var resolvedItem = rootResolver.GetNavigationRoot(contextItem);

            Assert.Equal(_rootItem.ID, resolvedItem.ID);
        }

        [Fact]
        public void ReturnsNullWhenNoNavigationRoot()
        {
            using (var db = new Db
            {
                new DbItem("Home")
                {
                    new DbItem("Child")
                }
            })
            {
                var contextItem = _db.GetItem("/sitecore/content/Home/Child");
                var rootResolver = new NavigationRootResolver();

                var resolvedItem = rootResolver.GetNavigationRoot(contextItem);

                Assert.Null(resolvedItem);
            }
        }

        [Fact]
        public void ReturnsNullWhenContextItemIsNull()
        {
            var rootResolver = new NavigationRootResolver();

            var resolvedItem = rootResolver.GetNavigationRoot(null);

            Assert.Null(resolvedItem);
        }
    }
}
