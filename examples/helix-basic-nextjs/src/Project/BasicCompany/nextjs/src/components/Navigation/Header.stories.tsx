import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import Header from './Header';
import { NavigationQuery } from './Navigation.graphql';
import { NavigationDataContext } from './NavigationDataContext';

export default {
  title: 'Navigation/Header',
  component: Header,
} as Meta;

const Template: Story = (args) => <Header {...args} />;

const navigationData: NavigationQuery = {
  item: {
    url: {
      path: '/',
    },
    navigationTitle: {
      value: 'Home',
    },
    headerLogo: {
      src: 'https://placekitten.com/139/45',
    },
    children: [
      {
        url: {
          path: '/Products',
        },
        navigationTitle: {
          value: 'Products',
        },
      },
      {
        url: {
          path: '/Services',
        },
        navigationTitle: {
          value: 'Services',
        },
      },
    ],
  },
};

export const WithNavigation = Template.bind({});
WithNavigation.decorators = [
  (Story) => (
    <NavigationDataContext value={navigationData}>
      <Story />
    </NavigationDataContext>
  ),
];
