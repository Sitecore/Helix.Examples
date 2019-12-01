using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sitecore.Data;

namespace BasicCompany.Feature.Services
{
  public static class Templates
  {
        public static class Testimonial
        {
            public static class Fields
            {
                public static readonly ID Image = new ID("{BF949588-0A7D-4452-9188-A298B40C0ED3}");
                public static readonly ID Title = new ID("{5AB05255-0825-4E6D-974B-623CD926E6FD}");
                public static readonly ID Quote = new ID("{861FE636-1545-4F59-AAB8-B308293139A1}");
            }
        }
  }
}