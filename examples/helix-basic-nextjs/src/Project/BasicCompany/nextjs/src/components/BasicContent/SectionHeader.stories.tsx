import React from 'react';
import { Meta, Story } from '@storybook/react/types-6-0';
import SectionHeader, { SectionHeaderProps } from './SectionHeader';

export default {
  title: 'Basic Content/Section Header',
  component: SectionHeader,
} as Meta;

const Template: Story<SectionHeaderProps> = (args) => <SectionHeader {...args} />;

export const WithText = Template.bind({});
WithText.args = {
  fields: {
    Text: {
      value: 'Commodo commodo mollit elit nisi sunt!',
    },
  },
};
