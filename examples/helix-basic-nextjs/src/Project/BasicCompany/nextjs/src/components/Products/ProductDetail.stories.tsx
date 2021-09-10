import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import { I18nProvider } from 'next-localization';
import ProductDetail, { ProductDetailFields } from './ProductDetail';
import { SitecoreContext } from '@sitecore-jss/sitecore-jss-nextjs';

export default {
  title: 'Products/ProductDetail',
  component: ProductDetail,
} as Meta;

const Template: Story = (args) => <ProductDetail {...args} />;

const dictionary = {
  ['Products-Detail-Price']: 'Price',
};

const context: ProductDetailFields = {
  route: {
    fields: {
      Features: {
        value: '<ul><li>Lorem</li><li>Ipsum</li></ul>',
      },
      Image: {
        value: {
          src: 'http://placekitten.com/480/306',
        },
      },
      Price: {
        value: '9.99',
      },
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
