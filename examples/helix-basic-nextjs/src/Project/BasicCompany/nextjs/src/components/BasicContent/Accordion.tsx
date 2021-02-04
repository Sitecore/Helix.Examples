import React from 'react';
import { ComponentRendering, Placeholder } from '@sitecore-jss/sitecore-jss-nextjs';

export type AccordionProps = {
  rendering: ComponentRendering;
};

const Accordion = ({ rendering }: AccordionProps): JSX.Element => (
  <div className="container accordion">
    <Placeholder name="accordion" rendering={rendering} />
  </div>
);

export default Accordion;
