import React from 'react';
import {
  ComponentRendering,
  LayoutServiceContext,
  Placeholder,
  useSitecoreContext,
} from '@sitecore-jss/sitecore-jss-nextjs';

export type TestimonialContainerProps = {
  rendering: ComponentRendering;
};

const TestimonialContainer = ({ rendering }: TestimonialContainerProps): JSX.Element => {
  const isEditing = useSitecoreContext<LayoutServiceContext>()?.sitecoreContext?.pageEditing;
  const placeholder = rendering?.placeholders?.testimonials;
  const isEmpty = placeholder?.filter((x) => (x as ComponentRendering).componentName).length == 0;

  return (
    <div className="container testimonials">
      <section className="columns is-1 is-multiline">
        {isEmpty && isEditing && (
          <div
            className="column"
            style={{ padding: '20px', border: '1px dotted black', textAlign: 'center' }}
          >
            <em>Add new testimonials here.</em>
          </div>
        )}
        <Placeholder rendering={rendering} name="testimonials"></Placeholder>
      </section>
    </div>
  );
};

export default TestimonialContainer;
