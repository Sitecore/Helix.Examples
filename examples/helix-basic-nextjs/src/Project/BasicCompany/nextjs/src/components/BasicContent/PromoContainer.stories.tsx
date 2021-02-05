import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import PromoContainer, { PromoContainerProps } from './PromoContainer';
import PromoCard from './PromoCard';
import { withFields } from './PromoCard.stories';
import {
  ComponentFactory,
  ComponentFields,
  SitecoreContext,
} from '@sitecore-jss/sitecore-jss-nextjs';

export default {
  title: 'Basic Content/Promo Container',
  component: PromoContainer,
} as Meta;

const Template: Story<PromoContainerProps> = (args) => <PromoContainer {...args} />;

// eslint-disable-next-line
const componentFactory: ComponentFactory = (_componentName: string): any => PromoCard;

export const WithPromos = Template.bind({});
WithPromos.decorators = [
  (Story) => (
    <SitecoreContext componentFactory={componentFactory} context={{}}>
      <Story />
    </SitecoreContext>
  ),
];
WithPromos.args = {
  rendering: {
    componentName: 'PromoContainer',
    placeholders: {
      promos: [
        {
          componentName: 'PromoCard',
          fields: withFields({
            headline: 'Ipsum sunt officia ea labore ut.',
            text:
              'Dolore adipisicing nostrud ad sint deserunt eu anim laboris non Lorem ullamco id qui.',
            imageUrl: 'http://placekitten.com/g/600/600',
            linkUrl: 'https://www.sitecore.com',
          }).fields as ComponentFields,
        },
        {
          componentName: 'PromoCard',
          fields: withFields({
            headline: 'Proident ipsum nulla enim qui consequat.',
            text: 'Irure proident ipsum sit est aute culpa amet sint elit proident.',
            imageUrl: 'http://placekitten.com/600/600',
            linkUrl: 'https://jss.sitecore.com',
          }).fields as ComponentFields,
        },
      ],
    },
  },
};

export const EmptyWhenEditing = Template.bind({});
EmptyWhenEditing.decorators = [
  (Story) => (
    <SitecoreContext componentFactory={componentFactory} context={{ pageEditing: true }}>
      <Story />
    </SitecoreContext>
  ),
];
EmptyWhenEditing.args = {
  rendering: {
    componentName: 'PromoContainer',
    placeholders: {
      promos: [],
    },
  },
};
