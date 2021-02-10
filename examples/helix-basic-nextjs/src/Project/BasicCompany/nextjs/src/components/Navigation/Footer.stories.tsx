import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import Footer from './Footer';
import { NavigationQuery } from './Navigation.graphql';
import { NavigationDataContext } from './NavigationDataContext';

export default {
  title: 'Navigation/Footer',
  component: Footer,
} as Meta;

const Template: Story = (args) => <Footer {...args} />;

const navigationData: NavigationQuery = {
  item: {
    url: {
      path: '/',
    },
    headerLogo: {
      src: 'https://placekitten.com/139/45',
    },
    footerCopyright: {
      value: 'Copyright Lorem Ipsum',
    },
    children: [],
  },
};

export const WithCopyright = Template.bind({});
WithCopyright.decorators = [
  (Story) => (
    <NavigationDataContext value={navigationData}>
      <Story />
    </NavigationDataContext>
  ),
];
