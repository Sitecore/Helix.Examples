import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import {
  ComponentFactory,
  ComponentFields,
  SitecoreContext,
} from '@sitecore-jss/sitecore-jss-nextjs';
import Testimonial from './Testimonial';
import TestimonialContainer, { TestimonialContainerProps } from './TestimonialContainer';
import { withFields } from './Testimonial.stories';

export default {
  title: 'Services/TestimonialContainer',
  component: TestimonialContainer,
} as Meta;

const Template: Story<TestimonialContainerProps> = (args) => <TestimonialContainer {...args} />;

// eslint-disable-next-line
const componentFactory: ComponentFactory = (_componentName: string): any => Testimonial;

export const WithTestimonials = Template.bind({});
WithTestimonials.decorators = [
  (Story) => (
    <SitecoreContext componentFactory={componentFactory} context={{}}>
      <Story />
    </SitecoreContext>
  ),
];
WithTestimonials.args = {
  rendering: {
    componentName: 'TestimonialContainer',
    placeholders: {
      testimonials: [
        {
          componentName: 'Testimonial',
          fields: withFields({
            title: 'Commodo sunt sunt aute tempor.',
            quote: '<p>Officia minim ad in elit aliqua sunt elit.</p>',
            imageSrc: 'https://placekitten.com/1920/1028/',
          }).fields as ComponentFields,
        },
        {
          componentName: 'Testimonial',
          fields: withFields({
            title: 'Qui ex enim consequat aliquip.',
            quote: '<p>Elit aliquip enim reprehenderit incididunt et amet ex.</p>',
            imageSrc: 'https://placekitten.com/g/1920/1028/',
          }).fields as ComponentFields,
        },
        {
          componentName: 'Testimonial',
          fields: withFields({
            title:
              'Ullamco aute aute laboris fugiat consectetur velit consectetur est cillum minim.',
            quote: '<p>Officia minim ad in elit aliqua sunt elit.</p>',
            imageSrc: 'https://placekitten.com/1920/1028/',
          }).fields as ComponentFields,
        },
        {
          componentName: 'Testimonial',
          fields: withFields({
            title:
              'Ullamco deserunt exercitation sint esse duis pariatur laboris sunt ea commodo ipsum veniam.',
            quote: '<p>Elit aliquip enim reprehenderit incididunt et amet ex.</p>',
            imageSrc: 'https://placekitten.com/g/1920/1028/',
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
    componentName: 'TestimonialContainer',
    placeholders: {
      promos: [],
    },
  },
};
