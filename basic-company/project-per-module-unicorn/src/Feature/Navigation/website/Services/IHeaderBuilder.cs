using BasicCompany.Feature.Navigation.Models;
using Sitecore.Data.Items;

namespace BasicCompany.Feature.Navigation.Services
{
    public interface IHeaderBuilder
    {
        Header GetHeader(Item contextItem);
    }
}
