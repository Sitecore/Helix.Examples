using Sitecore.AspNet.RenderingEngine.Binding.Attributes;
using System;
using System.Collections.Generic;
using System.Text;

namespace BasicCompany.Feature.Navigation.Models
{
    public class Header
    {
        /// <summary>
        /// Our bound property does not inherit from Field, so we need to bind it explicitly.
        /// </summary>
        [SitecoreComponentField]
        public NavigationItem[] NavItems { get; set; }

        [SitecoreComponentField]
        public LogoLink LogoLink { get; set; }
    }
}
