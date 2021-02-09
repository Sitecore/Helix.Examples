import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import Header, { HeaderProps } from './Header';
import { ComponentPropsCollection, ComponentPropsContext } from '@sitecore-jss/sitecore-jss-nextjs';
import { NavigationQuery } from './Header.graphql';

export default {
  title: 'Navigation/Header',
  component: Header,
} as Meta;

const Template: Story<HeaderProps> = (args) => <Header {...args} />;

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

const uid = 'mock-uid';
const componentProps: ComponentPropsCollection = {
  [uid]: navigationData,
};

export const WithNavigation = Template.bind({});
WithNavigation.decorators = [
  (Story) => (
    <ComponentPropsContext value={componentProps}>
      <Story />
    </ComponentPropsContext>
  ),
];
WithNavigation.args = {
  rendering: {
    componentName: 'Mock',
    uid,
  },
};
