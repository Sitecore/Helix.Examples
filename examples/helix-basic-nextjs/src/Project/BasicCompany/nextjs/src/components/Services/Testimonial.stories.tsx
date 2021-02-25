import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import Testimonial, { TestimonialProps } from './Testimonial';

export default {
  title: 'Services/Testimonial',
  excludeStories: ['withFields'],
  component: Testimonial,
} as Meta;

const Template: Story<TestimonialProps> = (args) => <Testimonial {...args} />;

export const withFields = (fields: {
  title: string;
  quote: string;
  imageSrc: string | undefined;
}): TestimonialProps => {
  return {
    fields: {
      Title: {
        value: fields.title,
      },
      Quote: {
        value: fields.quote,
      },
      Image: {
        value: {
          src: fields.imageSrc,
        },
      },
    },
  };
};

export const WithImage = Template.bind({});
WithImage.args = withFields({
  title: 'Laboris laboris culpa exercitation eu esse dolor laborum proident',
  quote: '<p>Officia et adipisicing eu duis elit reprehenderit Lorem culpa incididunt dolor.</p>',
  imageSrc: 'https://placekitten.com/1920/1028/',
});

export const MissingImage = Template.bind({});
MissingImage.args = withFields({
  title: 'Magna et voluptate ea commodo laborum.',
  quote:
    '<p>Consequat quis exercitation deserunt incididunt aute deserunt officia ipsum irure ullamco.</p>',
  imageSrc: undefined,
});
