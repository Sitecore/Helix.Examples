using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sitecore.Data;

namespace BasicCompany.Feature.Products
{
  public static class Templates
  {
		public static class Product
		{
			public static readonly ID Id = new ID("{ABCECB30-2777-48C7-8860-813E5268816C}");

            public static class Fields
            {
                public static readonly ID Title = new ID("{BE500A38-36A0-417B-86C5-E63BA71D0939}");
                public static readonly ID ShortDescription = new ID("{BE7E2D00-E405-4498-85F9-4F89D8EA2CFC}");
                public static readonly ID Image = new ID("{23F42F5E-645C-4A72-9C61-79DB1A331E64}");
            }
		}
  }
}