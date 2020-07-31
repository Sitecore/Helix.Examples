using Sitecore.AspNet.RenderingEngine.Binding.Attributes;
using Sitecore.LayoutService.Client.Response.Model.Fields;

namespace BasicCompany.Feature.Products.Models
{
    public class RelatedProductsList
    {
        public ContentListField<ListProduct> RelatedProducts { get; set; }
    }
}