using System.Diagnostics;
using System.Web.Mvc;
using BasicCompany.Feature.Navigation.Services;
using Sitecore.Mvc.Presentation;

namespace BasicCompany.Feature.Navigation.Controllers
{
    public class NavigationController : Controller
    {
        protected readonly INavigationRootResolver RootResolver;
        protected readonly IHeaderBuilder HeaderBuilder;

        public NavigationController(INavigationRootResolver rootResolver, IHeaderBuilder headerBuilder)
        {
            Debug.Assert(rootResolver != null);
            Debug.Assert(headerBuilder != null);
            RootResolver = rootResolver;
            HeaderBuilder = headerBuilder;
        }

        public ActionResult Header()
        {
            var header = HeaderBuilder.GetHeader(RenderingContext.Current.ContextItem);
            return View(header);
        }

        public ActionResult Footer()
        {
            var root = RootResolver.GetNavigationRoot(RenderingContext.Current.ContextItem);
            return View(root);
        }
    }
}