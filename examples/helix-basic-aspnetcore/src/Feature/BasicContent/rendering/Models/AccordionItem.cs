using System;
using System.Collections.Generic;
using System.Text;
using Sitecore.AspNet.RenderingEngine.Binding.Attributes;
using Sitecore.LayoutService.Client.Response.Model.Fields;

namespace BasicCompany.Feature.BasicContent.Models
{
    public class AccordionItem
    {
        public TextField Title { get; set; }
        
        public RichTextField Content { get; set; }

        [SitecoreContextProperty]
        public bool IsEditing { get; set; }
    }
}
