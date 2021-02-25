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
  const placeholder = rendering?.placeholders?.accordion;
  const isEmpty = placeholder?.filter((x) => (x as ComponentRendering).componentName).length == 0;
  return (
    <div className="container accordion">
      {isEmpty && isEditing && (
        <p style={{ padding: '20px', border: '1px dotted black' }}>
          <em>Add new accordion components here.</em>
        </p>
      )}
      <Placeholder name="accordion" rendering={rendering} />
    </div>
  );
};

export default Accordion;
