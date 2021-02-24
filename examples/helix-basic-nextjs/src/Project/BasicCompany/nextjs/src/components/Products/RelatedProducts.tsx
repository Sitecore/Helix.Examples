import {
  Field,
  ImageField,
  useSitecoreContext,
  Text,
  RichText,
  mediaApi,
} from '@sitecore-jss/sitecore-jss-nextjs';
import { useI18n } from 'next-localization';

type RelatedProductsProps = {
  route: {
    fields: {
      RelatedProducts: [
        {
          url: string;
          fields: {
            Title: Field<string>;
            ShortDescription: Field<string>;
            Image: ImageField;
          };
        }
      ];
    };
  };
};

const RelatedProducts = (): JSX.Element => {
  const { t } = useI18n();
  const {
    sitecoreContext: {
      route: { fields },
    },
  } = useSitecoreContext<RelatedProductsProps>();
  return (
    <div className="container">
      <h3 className="title">{t('Products-RelatedProducts-Title')}</h3>

      <div className="product-list-columns columns is-multiline">
        {fields.RelatedProducts &&
          fields.RelatedProducts.map((product) => {
            const productImage = product.fields.Image.value?.src;
            const figureStyle = productImage
              ? {
                  backgroundImage: `url(${mediaApi.updateImageUrl(productImage, { mw: 480 })})`,
                }
              : {};
            return (
              <a
                key={product.url}
                href={product.url}
                className="column product-list-column is-4-desktop is-6-tablet"
              >
                <div className="card">
                  <div className="card-image">
                    <figure style={figureStyle}></figure>
                  </div>
                  <div className="card-content">
                    <div className="content">
                      <Text field={product.fields.Title} tag="h4" />
                      <RichText field={product.fields.ShortDescription} tag="p" />
                    </div>
                  </div>
                </div>
              </a>
            );
          })}
      </div>
    </div>
  );
};

export default RelatedProducts;
