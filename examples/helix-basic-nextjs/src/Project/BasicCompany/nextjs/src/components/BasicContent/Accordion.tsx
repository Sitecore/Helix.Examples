import React from 'react';
import {
  ComponentRendering,
  Placeholder,
  useSitecoreContext,
  LayoutServiceContext,
} from '@sitecore-jss/sitecore-jss-nextjs';

export type AccordionProps = {
  rendering: ComponentRendering;
};

const Accordion = ({ rendering }: AccordionProps): JSX.Element => {
  const isEditing = useSitecoreContext<LayoutServiceContext>()?.sitecoreContext?.pageEditing;
  return (
    <div className="container accordion">
      <Placeholder name="accordion" rendering={rendering} />
      {rendering?.placeholders?.accordion && isEditing && (
        <p style={{ padding: '20px', border: '1px dotted black' }}>
          <em>Add new accordion components here.</em>
        </p>
      )}
    </div>
  );
};

export default Accordion;
