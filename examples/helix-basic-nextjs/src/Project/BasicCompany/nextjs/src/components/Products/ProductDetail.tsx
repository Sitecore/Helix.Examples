import React from 'react';
import { useI18n } from 'next-localization';
import {
  useSitecoreContext,
  Text,
  RichText,
  Image,
  Field,
  ImageField,
} from '@sitecore-jss/sitecore-jss-nextjs';

export type ProductDetailFields = {
  route: {
    fields: {
      Features: Field<string>;
      Price: Field<string>;
      Image: ImageField;
    };
  };
};

const ProductDetail = (): JSX.Element => {
  const { t } = useI18n();
  const {
    sitecoreContext: {
      route: { fields },
    },
  } = useSitecoreContext<ProductDetailFields>();
  return (
    <section className="product-detail columns is-centered is-vcentered">
      <div className="product-details column is-narrow has-text-centered-mobile">
        <h5>{t('Products-Detail-Price')}</h5>
        <p className="price">
          $<Text field={fields?.Price} />
        </p>
        <RichText field={fields?.Features} />
      </div>
      <div className="product-image column is-3">
        <Image field={fields?.Image} imageParams={{ mw: 480, as: 0 }} />
      </div>
    </section>
  );
};

export default ProductDetail;
