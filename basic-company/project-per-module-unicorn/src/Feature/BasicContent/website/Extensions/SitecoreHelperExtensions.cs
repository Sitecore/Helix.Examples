using Sitecore.Data;
using Sitecore.Data.Fields;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.BasicContent.Extensions
{
    public static class SitecoreHelperExtensions
    {
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