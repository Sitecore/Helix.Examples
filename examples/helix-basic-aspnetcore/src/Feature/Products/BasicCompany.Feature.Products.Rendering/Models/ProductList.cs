using System.Collections.Generic;
using Sitecore.AspNet.RenderingEngine.Binding.Attributes;

namespace BasicCompany.Feature.Products.Models
{
    public class ProductList
    {
        [SitecoreComponentField]
        public IEnumerable<ListProduct> Products { get; set; }
    }
}
