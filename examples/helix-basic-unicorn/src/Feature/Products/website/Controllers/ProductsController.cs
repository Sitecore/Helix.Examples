using System.Diagnostics;
using System.Web.Mvc;
using BasicCompany.Feature.Products.Services;
using Sitecore.Mvc.Presentation;

namespace BasicCompany.Feature.Products.Controllers
{
    public class ProductsController : Controller
    {
        protected readonly IProductRepository ProductRepository;

        public ProductsController(IProductRepository productRepository)
        {
            Debug.Assert(productRepository != null);
            ProductRepository = productRepository;
        }

        public ActionResult List()
        {
            var productRoot = RenderingContext.Current.ContextItem;
            var products = ProductRepository.GetProducts(productRoot);
            return View(products);
        }
    }
}