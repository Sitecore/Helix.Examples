import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import ListProduct, { ListProductProps } from './ListProduct';

export default {
  title: 'Products/ListProduct',
  component: ListProduct,
} as Meta;

const Template: Story<ListProductProps> = (args) => (
  <ListProduct {...args}>
    <h4>Exercitation dolore ad</h4>
    <p>Ipsum Lorem ipsum sunt enim irure incididunt laborum nostrud.</p>
  </ListProduct>
);

export const Product = Template.bind({});
Product.args = {
  url: 'http://www.sitecore.com',
  imageSrc: 'http://placekitten.com/480/306',
};
