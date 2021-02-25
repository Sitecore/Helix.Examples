import React from 'react';
import { useSitecoreContext, Text, Field } from '@sitecore-jss/sitecore-jss-nextjs';

export type ProductDetailHeaderFields = {
  route: {
    fields: {
      Title: Field<string>;
      ShortDescription: Field<string>;
    };
  };
};

const ProductDetailHeader = (): JSX.Element => {
  const {
    sitecoreContext: {
      route: { fields },
    },
  } = useSitecoreContext<ProductDetailHeaderFields>();

  return (
    <div className="container">
      <section className="hero is-small product-detail-hero">
        <div className="hero-body">
          <Text field={fields?.Title} tag="h1" className="title" />
          <Text field={fields?.ShortDescription} tag="h2" className="subtitle is-one-quarter" />
        </div>
      </section>
    </div>
  );
};

export default ProductDetailHeader;
