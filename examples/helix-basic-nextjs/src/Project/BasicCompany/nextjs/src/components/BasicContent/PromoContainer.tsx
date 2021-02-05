import React from 'react';
import { ComponentRendering, Placeholder } from '@sitecore-jss/sitecore-jss-nextjs';

export type PromoContainerProps = {
  rendering: ComponentRendering;
};

const PromoContainer = ({ rendering }: PromoContainerProps): JSX.Element => (
  <div className="container">
    <div className="columns">
      <Placeholder name="promos" rendering={rendering} />
    </div>
  </div>
);

export default PromoContainer;
