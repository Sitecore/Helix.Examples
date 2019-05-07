using System.Web;
using Sitecore.Data;
using Sitecore.Data.Fields;
using Sitecore.Data.Items;
using Sitecore.Links;
using Sitecore.Mvc.Helpers;
using Sitecore.Resources.Media;

namespace BasicCompany.Foundation.FieldRendering
{
    public static class SitecoreHelperExtensions
    {
        public static HtmlString Field(this SitecoreHelper helper, ID fieldID)
        {
            return helper.Field(fieldID.ToString());
        }

        public static HtmlString Field(this SitecoreHelper helper, ID fieldID, Item item)
        {
            return helper.Field(fieldID.ToString(), item);
        }

        public static string MediaUrl(this SitecoreHelper sitecoreHelper, ID fieldId)
        {
            return MediaUrl(sitecoreHelper, fieldId, sitecoreHelper.CurrentItem);
        }

        public static string MediaUrl(this SitecoreHelper sitecoreHelper, ID fieldId, Item item)
        {
            ImageField imageField = item.Fields[fieldId];
            return imageField.MediaItem != null ? MediaManager.GetMediaUrl(imageField.MediaItem) : string.Empty;
        }

        public static string ItemUrl(this SitecoreHelper sitecoreHelper, Item item)
        {
            return LinkManager.GetItemUrl(item);
        }
    }
}