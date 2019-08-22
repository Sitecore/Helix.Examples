using System.Collections.Generic;
using Sitecore.Data;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.Products.Services
{
    public interface IProductRepository
    {
        IEnumerable<Item> GetProducts(Item parent);
    }
}
