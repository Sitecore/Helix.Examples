using System.Collections.Generic;
using System.Linq;
using Moq;
using Sitecore.Collections;
using Sitecore.Data;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.Navigation.Tests
{
    internal static class MockItemExtensions
    {
        public static Mock<Item> DescendsFrom(this Mock<Item> mock, ID templateId)
        {
            mock.Setup(x => x.DescendsFrom(templateId)).Returns(true);
            return mock;
        }

        public static Mock<Item> WithAncestors(this Mock<Item> mock, Item[] ancestors)
        {
            mock.Setup(x => x.Axes.GetAncestors()).Returns(ancestors);
            return mock;
        }

        public static Mock<Item> WithChildren(this Mock<Item> mock, IEnumerable<Item> children)
        {
            var childList = new ChildList(mock.Object, children.ToList());
            mock.SetupGet(x => x.Children).Returns(childList);
            return mock;
        }

        public static Mock<Item> WithTemplate(this Mock<Item> mock, ID templateId)
        {
            mock.Setup(x => x.TemplateID).Returns(templateId);
            return mock;
        }
    }
}