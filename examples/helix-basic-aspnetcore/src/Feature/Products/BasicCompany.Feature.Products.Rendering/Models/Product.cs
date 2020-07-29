using System.Runtime.Serialization;
using Sitecore.AspNet.RenderingEngine.Binding.Attributes;
using Sitecore.LayoutService.Client.Response.Model.Fields;

namespace BasicCompany.Feature.Products.Models
{
    public class Product
    {
        public TextField Title { get; set; }

        [DataMember(Name = "Short Description")]
        [SitecoreComponentField(Name = "Short Description")]
        public TextField ShortDescription { get; set; }

        public ImageField Image { get; set; }

        public RichTextField Features { get; set; }

        public NumberField Price { get; set; }

        [DataMember(Name = "Related Products")]
        [SitecoreComponentField(Name = "Related Products")]
        public ContentListField<Product> RelatedProducts { get; set; }
    }
}
