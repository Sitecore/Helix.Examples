using System.Web;
using Sitecore.Data;
using Sitecore.Data.Fields;
using Sitecore.Data.Items;
using Sitecore.Links;
using Sitecore.Links.UrlBuilders;
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

        public static HtmlString Field(this SitecoreHelper helper, ID fieldID, object parameters)
        {
            return helper.Field(fieldID.ToString(), parameters);
        }

        public static HtmlString Field(this SitecoreHelper helper, ID fieldID, Item item)
        {
            return helper.Field(fieldID.ToString(), item);
        }

        public static string MediaUrl(this SitecoreHelper sitecoreHelper, ID fieldId)
        {
            return MediaUrl(sitecoreHelper, fieldId, sitecoreHelper.CurrentItem);
        }

		public static string MediaUrl(this SitecoreHelper sitecoreHelper, ID fieldId, MediaUrlBuilderOptions options)
		{
			return MediaUrl(sitecoreHelper, fieldId, sitecoreHelper.CurrentItem, options);
		}

		public static string MediaUrl(this SitecoreHelper sitecoreHelper, ID fieldId, Item item)
        {
			return MediaUrl(sitecoreHelper, fieldId, item, null);
		}

		public static string MediaUrl(this SitecoreHelper sitecoreHelper, ID fieldId, Item item, MediaUrlBuilderOptions options)
		{
			ImageField imageField = item?.Fields[fieldId];
            if (imageField == null || imageField.MediaItem == null)
            {
                return string.Empty;
            }
			var url = options != null ? MediaManager.GetMediaUrl(imageField.MediaItem, options) : MediaManager.GetMediaUrl(imageField.MediaItem);
            return HashingUtils.ProtectAssetUrl(url);
		}

		public static string ItemUrl(this SitecoreHelper sitecoreHelper, Item item)
        {
            return LinkManager.GetItemUrl(item);
        }
    }
}