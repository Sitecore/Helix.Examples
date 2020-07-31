using System.Diagnostics;
using System.Linq;
using BasicCompany.Feature.Products.Services;
using Newtonsoft.Json.Linq;
using Sitecore.Abstractions;
using Sitecore.LayoutService.Configuration;
using Sitecore.LayoutService.Serialization.ItemSerializers;
using Sitecore.Mvc.Presentation;

namespace BasicCompany.Feature.Products.LayoutService
{
    public class ProductListContentsResolver : Sitecore.LayoutService.ItemRendering.ContentsResolvers.RenderingContentsResolver
    {
        protected readonly IProductRepository ProductRepository;
        protected readonly BaseLinkManager LinkManager;

        public ProductListContentsResolver(IProductRepository productRepository, BaseLinkManager linkManager)
        {
            Debug.Assert(productRepository != null);
            Debug.Assert(linkManager != null);
            ProductRepository = productRepository;
            LinkManager = linkManager;
        }

        public override object ResolveContents(Rendering rendering, IRenderingConfiguration renderingConfig)
        {
            var productsRoot = GetContextItem(rendering, renderingConfig);
            var products = ProductRepository.GetProducts(productsRoot);
            return new
            {
                // Use the inherited method to get the JSON serialized item, then reduce the returned fields
                Products = products.Select(item => new
                    {
                        Item = item,
                        Serialized = base.ProcessItem(item, rendering, renderingConfig)
                    })
                    .Select(product => new
                    {
                        // Create object shape expected by ItemLinkField
                        Url = LinkManager.GetItemUrl(product.Item),
                        Id = product.Item.ID,
                        Fields = new
                        {
                            Title = product.Serialized[product.Item.Fields[Templates.Product.Fields.Title].Name],
                            ShortDescription = product.Serialized[product.Item.Fields[Templates.Product.Fields.ShortDescription].Name],
                            Image = product.Serialized[product.Item.Fields[Templates.Product.Fields.Image].Name]
                        }
                    })
            };
        }
    }
}