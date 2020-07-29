using Sitecore.LayoutService.Client.Response.Model.Fields;

namespace BasicCompany.Feature.Products.Models
{
    public class ListProduct
    {
        public string Url { get; set; }

        public TextField Title { get; set; }

        public TextField ShortDescription { get; set; }

        public ImageField Image { get; set; }
    }
}
