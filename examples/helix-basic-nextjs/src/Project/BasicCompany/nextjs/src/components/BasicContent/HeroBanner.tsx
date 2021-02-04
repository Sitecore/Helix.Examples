import { Text, Field, ImageField } from '@sitecore-jss/sitecore-jss-nextjs';

export type HeroBannerProps = {
  fields: {
    Title: Field<string>;
    Subtitle: Field<string>;
    Image: ImageField;
  };
};

const HeroBanner = ({ fields }: HeroBannerProps): JSX.Element => {
  const bannerStyle = {
    backgroundImage: `url(${fields.Image?.value?.src})`,
  };
  return (
    <section className="hero is-medium is-black" style={bannerStyle}>
      <div className="hero-body">
        <div className="container">
          <Text field={fields.Title} tag="h1" className="title" />
          <Text field={fields.Subtitle} tag="h2" className="title" />
        </div>
      </div>
    </section>
  );
};

export default HeroBanner;
