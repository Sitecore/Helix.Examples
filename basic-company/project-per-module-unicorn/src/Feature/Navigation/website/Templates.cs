using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sitecore.Data;

namespace BasicCompany.Feature.Navigation
{
  public static class Templates
  {
        public static class NavigationItem
        {
            public static readonly ID Id = new ID("{C231FBB4-DCDB-4708-99BC-94760F222CC5}");
            public static class Fields
            {
                public static readonly ID NavigationTitle = new ID("{32CFF90D-4FDF-4402-A364-21199E88753D}");
            }
        }

        public static class NavigationRoot
        {
            public static readonly ID Id = new ID("{D7F870BC-89D8-4F17-95EC-59ACFD7DA05C}");

            public static class Fields
            {
                public static readonly ID HeaderLogo = new ID("{FEE16E6B-0823-44FB-ACD2-F56DB2011AA3}");
                public static readonly ID FooterCopyright = new ID("{F6098004-9129-41E4-A3B0-604A7583C26D}");
            }
        }
  }
}