import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import ProductDetailHeader, { ProductDetailHeaderFields } from './ProductDetailHeader';
import { SitecoreContext } from '@sitecore-jss/sitecore-jss-nextjs';

export default {
  title: 'Products/ProductDetailHeader',
  component: ProductDetailHeader,
} as Meta;

const Template: Story = (args) => <ProductDetailHeader {...args} />;

const context: ProductDetailHeaderFields = {
  route: {
    fields: {
      Title: {
        value: 'Laborum tempor adipisicing consectetur culpa',
      },
      ShortDescription: {
        value:
          'Laboris labore dolor consectetur excepteur reprehenderit sint dolore ea nulla ex non.',
      },
    },
  },
};

export const Product = Template.bind({});
Product.decorators = [
  (Story) => (
    <SitecoreContext
      // eslint-disable-next-line
      componentFactory={(_componentName: string) => null}
      context={context}
    >
      <Story />
    </SitecoreContext>
  ),
];
