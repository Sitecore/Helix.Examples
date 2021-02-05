import React from 'react';
import {
  ComponentRendering,
  Placeholder,
  useSitecoreContext,
  LayoutServiceContext,
} from '@sitecore-jss/sitecore-jss-nextjs';

export type PromoContainerProps = {
  rendering: ComponentRendering;
};

const PromoContainer = ({ rendering }: PromoContainerProps): JSX.Element => {
  const isEditing = useSitecoreContext<LayoutServiceContext>()?.sitecoreContext?.pageEditing;
  return (
    <div className="container">
      <div className="columns">
        <Placeholder name="promos" rendering={rendering} />
        {rendering?.placeholders?.promos && isEditing && (
          <p style={{ padding: '20px', border: '1px dotted black' }}>
            <em>Add new promo components here.</em>
          </p>
        )}
      </div>
    </div>
  );
};

export default PromoContainer;
