using Sitecore.Data;
using Sitecore.Data.Fields;
using Sitecore.Data.Items;
using Sitecore.Links;

namespace BasicCompany.Feature.Products.Extensions
{
    public static class SitecoreHelperExtensions
    {
        public static string ItemUrl(this Sitecore.Mvc.Helpers.SitecoreHelper sitecoreHelper, Item item)
        {
            return LinkManager.GetItemUrl(item);
        }

        public static string MediaUrl(this Sitecore.Mvc.Helpers.SitecoreHelper sitecoreHelper, ID fieldId)
        {
            return MediaUrl(sitecoreHelper, fieldId, sitecoreHelper.CurrentItem);
        }

        public static string MediaUrl(this Sitecore.Mvc.Helpers.SitecoreHelper sitecoreHelper, ID fieldId, Item item)
        {
            ImageField imageField = item.Fields[fieldId];
            return imageField.MediaItem != null ? Sitecore.Resources.Media.MediaManager.GetMediaUrl(imageField.MediaItem) : string.Empty;
        }
    }
}