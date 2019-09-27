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
                public static readonly ID Features = new ID("{2C2C386C-17C7-44C3-8796-3E720BA08079}");
                public static readonly ID Price = new ID("{9977FBE7-A0FF-475C-9A7C-ECB81C7F51CF}");
                public static readonly ID RelatedProducts = new ID("{FC7C99D4-7301-44EB-908C-BF4FFCA5A131}");
            }
        }
  }
}