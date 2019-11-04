using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using Moq;
using Sitecore.Collections;
using Sitecore.Data;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.Navigation.Tests
{
    internal static class ItemMock
    {
        public static Mock<Item> New()
        {
            var item = new Mock<Item>(ID.NewID, ItemData.Empty, Mock.Of<Database>());

            var axes = new Mock<ItemAxes>(item.Object);
            axes.Setup(x => x.GetAncestors()).Returns(Array.Empty<Item>());
            item.Setup(x => x.Axes).Returns(axes.Object);

            var childList = new Mock<ChildList>(item.Object, Enumerable.Empty<Item>());
            item.Setup(x => x.Children).Returns(childList.Object);

            var itemPath = new Mock<ItemPath>(item.Object);
            itemPath.SetupGet(x => x.LongID).Returns(item.Object.ID.ToString);
            item.Setup(x => x.Paths).Returns(itemPath.Object);

            return item;
        }

        public static Mock<Item> New(string name)
        {
            var mock = New();
            mock.Setup(x => x.Name).Returns(name);
            return mock;
        }

        public static Item NewObject()
        {
            return New().Object;
        }

        public static Item NewObject(string name)
        {
            return New(name).Object;
        }

        public static IReadOnlyCollection<Item> NewListOf(int count)
        {
            var list = new Collection<Item>();
            while (count > 0)
            {
                --count;
                list.Add(NewObject());
            }

            return list;
        }
    }
}