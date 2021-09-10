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
  const placeholder = rendering?.placeholders?.promos;
  const isEmpty = placeholder?.filter((x) => (x as ComponentRendering).componentName).length == 0;
  return (
    <div className="container">
      <div className="columns">
        {isEmpty && isEditing && (
          <div
            className="column"
            style={{ padding: '20px', border: '1px dotted black', textAlign: 'center' }}
          >
            <em>Add new promo components here.</em>
          </div>
        )}
        <Placeholder name="promos" rendering={rendering} />
      </div>
    </div>
  );
};

export default PromoContainer;
