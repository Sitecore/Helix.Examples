import React from 'react';
import { Field, ImageField, Text, RichText } from '@sitecore-jss/sitecore-jss-nextjs';

export type TestimonialProps = {
  fields: {
    Quote: Field<string>;
    Title: Field<string>;
    Image: ImageField;
  };
};

const Testimonial = ({ fields }: TestimonialProps): JSX.Element => {
  const testimonialStyle = {
    backgroundImage: `url(${fields?.Image?.value?.src})`,
  };
  return (
    <div className="column testimonial is-6">
      <div className="testimonial-inner" style={testimonialStyle}>
        <Text field={fields.Title} />
        <RichText field={fields.Quote} />
      </div>
    </div>
  );
};

export default Testimonial;
