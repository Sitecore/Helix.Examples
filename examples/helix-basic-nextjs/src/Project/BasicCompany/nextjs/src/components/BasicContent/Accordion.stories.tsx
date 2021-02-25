import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import Accordion, { AccordionProps } from './Accordion';
import { ComponentFactory, SitecoreContext } from '@sitecore-jss/sitecore-jss-nextjs';
import { withFields } from './AccordionItem.stories';
import AccordionItem from './AccordionItem';

export default {
  title: 'Basic Content/Accordion',
  component: Accordion,
} as Meta;

const Template: Story<AccordionProps> = (args) => <Accordion {...args} />;

// eslint-disable-next-line
const componentFactory: ComponentFactory = (_componentName: string): any => AccordionItem;

export const WithAccordions = Template.bind({});
WithAccordions.decorators = [
  (Story) => (
    <SitecoreContext componentFactory={componentFactory} context={{}}>
      <Story />
    </SitecoreContext>
  ),
];
WithAccordions.args = {
  rendering: {
    componentName: 'Accordion',
    placeholders: {
      accordion: [
        {
          componentName: 'AccordionItem',
          ...withFields({
            title: 'Aliqua excepteur culpa magna aliqua officia',
            content:
              'Velit incididunt commodo culpa id. Duis ex excepteur sunt et in consequat Lorem minim ea.',
          }),
        },
        {
          componentName: 'AccordionItem',
          ...withFields({
            title: 'Irure voluptate incididunt nulla cupidatat ipsum.',
            content:
              'Voluptate dolore eu ex incididunt nisi. Excepteur laboris laboris reprehenderit nisi cupidatat ullamco dolore nostrud sunt in exercitation ea cillum.',
          }),
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
    componentName: 'Accordion',
    placeholders: {
      accordion: [],
    },
  },
};
