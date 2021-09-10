import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import AccordionItem, { AccordionItemProps } from './AccordionItem';
import { SitecoreContext } from '@sitecore-jss/sitecore-jss-nextjs';

export default {
  title: 'Basic Content/Accordion Item',
  component: AccordionItem,
  excludeStories: ['withFields'],
} as Meta;

const Template: Story<AccordionItemProps> = (args) => <AccordionItem {...args} />;

export const withFields = (fields: { title: string; content: string }): AccordionItemProps => {
  return {
    fields: {
      Title: {
        value: fields.title,
      },
      Content: {
        value: fields.content,
      },
    },
  };
};

export const WithAllFields = Template.bind({});
WithAllFields.args = withFields({
  title: 'Ut adipisicing velit qui labore duis fugiat',
  content: `<p>Esse commodo mollit magna consequat proident ea deserunt culpa dolor ut occaecat aute reprehenderit.
    Est nulla ullamco <strong>eiusmod</strong> consequat.</p>
    <ul>
        <li>Anim eu sint qui cupidatat commodo tempor voluptate deserunt proident commodo</li>
        <li>Labore quis ut ipsum Lorem.</li>
        <li>Voluptate eiusmod occaecat voluptate proident dolor.</li>
    </ul>
    <p>Aute ipsum. Commodo ullamco consequat anim velit. Occaecat est Lorem nostrud deserunt ipsum deserunt culpa cillum.
    Tempor id non culpa deserunt anim ipsum.</p>`,
});

export const Editing = Template.bind({});
Editing.decorators = [
  (Story) => (
    <SitecoreContext
      // eslint-disable-next-line
      componentFactory={(_componentName: string) => null}
      context={{ pageEditing: true }}
    >
      <Story />
    </SitecoreContext>
  ),
];
Editing.args = withFields({
  title: 'You cannot close this accordion',
  content: 'Dolore duis veniam enim non nostrud mollit id elit et cupidatat.',
});
