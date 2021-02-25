import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import { I18nProvider } from 'next-localization';
import RelatedProducts, { RelatedProductFields, RelatedProductsFields } from './RelatedProducts';
import { SitecoreContext } from '@sitecore-jss/sitecore-jss-nextjs';

export default {
  title: 'Products/RelatedProducts',
  component: RelatedProducts,
} as Meta;

const Template: Story = () => <RelatedProducts />;

const dictionary = {
  ['Products-RelatedProducts-Title']: 'Related Products',
};

const getRelatedProduct = (fields: {
  url: string;
  title: string;
  description: string;
  imageSrc: string;
}): RelatedProductFields => {
  return {
    url: fields.url,
    fields: {
      Title: {
        value: fields.title,
      },
      ShortDescription: {
        value: fields.description,
      },
      Image: {
        value: {
          src: fields.imageSrc,
        },
      },
    },
  };
};

const context: RelatedProductsFields = {
  route: {
    fields: {
      RelatedProducts: [
        getRelatedProduct({
          url: 'http://www.sitecore.com',
          title: 'Exercitation mollit et excepteur labore laborum',
          description: 'Sunt voluptate tempor enim irure est ullamco.',
          imageSrc: 'http://placekitten.com/480/306',
        }),
        getRelatedProduct({
          url: 'http://www.sitecore.com',
          title: 'Ad enim velit sint est incididunt veniam officia',
          description: 'Excepteur duis irure tempor nisi voluptate elit sunt.',
          imageSrc: 'http://placekitten.com/480/306',
        }),
        getRelatedProduct({
          url: 'http://www.sitecore.com',
          title: 'Exercitation mollit et excepteur labore laborum',
          description: 'Sunt voluptate tempor enim irure est ullamco.',
          imageSrc: 'http://placekitten.com/480/306',
        }),
        getRelatedProduct({
          url: 'http://www.sitecore.com',
          title: 'Ad enim velit sint est incididunt veniam officia',
          description: 'Excepteur duis irure tempor nisi voluptate elit sunt.',
          imageSrc: 'http://placekitten.com/480/306',
        }),
      ],
    },
  },
};

export const Product = Template.bind({});
Product.decorators = [
  (Story) => (
    <I18nProvider lngDict={dictionary} locale="en">
      <SitecoreContext
        // eslint-disable-next-line
        componentFactory={(_componentName: string) => null}
        context={context}
      >
        <Story />
      </SitecoreContext>
    </I18nProvider>
  ),
];
