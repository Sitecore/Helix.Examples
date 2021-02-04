import {
  Text,
  RichText,
  Link,
  Field,
  ImageField,
  LinkField,
} from '@sitecore-jss/sitecore-jss-nextjs';
import { ReactNode } from 'react';

export type PromoCardProps = {
  fields: {
    Link: LinkField;
    Image: ImageField;
    Headline: Field<string>;
    Text: Field<string>;
  };
};

type PromoCardWrapperProps = {
  linkField: LinkField;
  children: ReactNode;
};

const PromoCardWrapper: React.FunctionComponent<PromoCardWrapperProps> = ({
  linkField,
  children,
}) => {
  const wrapperProps = {
    className: 'column promo-column',
  };
  return linkField?.value?.href ? (
    <Link field={linkField} editable={false} {...wrapperProps}>
      {children}
    </Link>
  ) : (
    <div {...wrapperProps}>{children}</div>
  );
};

const PromoCard = ({ fields }: PromoCardProps): JSX.Element => {
  const figureStyle = {
    backgroundImage: `url(${fields.Image?.value?.src})`,
  };
  return (
    <PromoCardWrapper linkField={fields.Link}>
      <div className="card">
        <div className="card-image">
          <figure style={figureStyle}></figure>
        </div>
        <div className="card-content">
          <div className="content">
            <Text field={fields.Headline} tag="h4" />
            <RichText field={fields.Text} />
          </div>
        </div>
      </div>
    </PromoCardWrapper>
  );
};

export default PromoCard;
