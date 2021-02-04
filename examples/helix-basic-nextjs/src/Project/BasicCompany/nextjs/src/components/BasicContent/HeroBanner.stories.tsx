import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import HeroBanner, { HeroBannerProps } from './HeroBanner';

export default {
  title: 'Basic Content/Hero Banner',
  component: HeroBanner,
} as Meta;

const Template: Story<HeroBannerProps> = (args) => <HeroBanner {...args} />;

const withFields = (fields: {
  title: string;
  subtitle: string;
  imageUrl: string | undefined;
}): HeroBannerProps => {
  return {
    fields: {
      Title: {
        value: fields.title,
      },
      Subtitle: {
        value: fields.subtitle,
      },
      Image: {
        value: {
          src: fields.imageUrl,
        },
      },
    },
  };
};

export const WithImage = Template.bind({});
WithImage.args = withFields({
  title: 'Lorem ipsum dolor sit',
  subtitle: 'Aenean pharetra leo',
  imageUrl: 'https://placekitten.com/1920/510',
});

export const WithoutImage = Template.bind({});
WithoutImage.args = withFields({
  title: 'Do ea mollit eu duis',
  subtitle: 'In mollit in ea',
  imageUrl: undefined,
});
