import {
  Field,
  ImageField,
  useSitecoreContext,
  Text,
  RichText,
} from '@sitecore-jss/sitecore-jss-nextjs';
import { useI18n } from 'next-localization';
import ListProduct from 'src/Helpers/ListProduct';

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
          fields.RelatedProducts.map((product) => (
            <ListProduct
              key={product.url}
              url={product.url}
              imageSrc={product.fields.Image.value?.src}
            >
              <Text field={product.fields.Title} tag="h4" />
              <RichText field={product.fields.ShortDescription} tag="p" />
            </ListProduct>
          ))}
      </div>
    </div>
  );
};

export default RelatedProducts;
