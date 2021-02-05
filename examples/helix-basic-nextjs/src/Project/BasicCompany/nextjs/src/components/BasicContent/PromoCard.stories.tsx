import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import PromoCard, { PromoCardProps } from './PromoCard';

export default {
  title: 'Basic Content/Promo Card',
  component: PromoCard,
  excludeStories: ['withFields'],
} as Meta;

const Template: Story<PromoCardProps> = (args) => <PromoCard {...args} />;

export const withFields = (fields: {
  linkUrl: string | undefined;
  imageUrl: string | undefined;
  headline: string;
  text: string;
}): PromoCardProps => {
  return {
    fields: {
      Link: {
        value: {
          href: fields.linkUrl,
        },
      },
      Image: {
        value: {
          src: fields.imageUrl,
        },
      },
      Headline: {
        value: fields.headline,
      },
      Text: {
        value: fields.text,
      },
    },
  };
};

export const AllFields = Template.bind({});
AllFields.args = withFields({
  linkUrl: 'https://www.sitecore.com',
  imageUrl: 'https://placekitten.com/600/400/',
  headline: 'Tempor non incididunt ea',
  text:
    '<p>Officia <em>consequat</em> adipisicing in magna dolore deserunt consequat consequat ex irure.</p>',
});

export const MissingLink = Template.bind({}); //we found it!
MissingLink.args = withFields({
  linkUrl: undefined,
  imageUrl: 'https://placekitten.com/600/400/',
  headline: 'Exercitation dolore ex tempor',
  text:
    '<p>Lorem adipisicing qui <strong>minim</strong> est dolore cupidatat occaecat fugiat sunt.</p>',
});
