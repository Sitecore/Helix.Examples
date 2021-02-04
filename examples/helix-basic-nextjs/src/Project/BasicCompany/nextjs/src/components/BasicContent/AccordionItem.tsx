import React, { useState } from 'react';
import {
  Text,
  RichText,
  Field,
  useSitecoreContext,
  LayoutServiceContext,
} from '@sitecore-jss/sitecore-jss-nextjs';

export type AccordionItemProps = {
  fields: {
    Title: Field<string>;
    Content: Field<string>;
  };
};

const AccordionItem = ({ fields }: AccordionItemProps): JSX.Element => {
  // when editing, default to open, and keep open
  const { sitecoreContext } = useSitecoreContext<LayoutServiceContext>();
  const isEditing = sitecoreContext && sitecoreContext.pageEditing;

  const [isActive, setActiveState] = useState(isEditing);

  const toggleAccordion = () => {
    setActiveState(isEditing || !isActive);
  };

  return (
    <div className={`accordion-item ${isActive ? 'is-active' : ''}`}>
      <div className="accordion-header">
        <Text field={fields.Title} tag="h3" />
        <button onClick={toggleAccordion}></button>
      </div>
      <div className="accordion-body">
        <RichText field={fields.Content} />
      </div>
    </div>
  );
};

export default AccordionItem;
