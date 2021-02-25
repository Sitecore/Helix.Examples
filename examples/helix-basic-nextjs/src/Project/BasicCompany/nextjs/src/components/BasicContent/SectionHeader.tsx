import { Text, Field } from '@sitecore-jss/sitecore-jss-nextjs';

export type SectionHeaderProps = {
  fields: {
    Text: Field<string>;
  };
};

const SectionHeader = ({ fields }: SectionHeaderProps): JSX.Element => (
  <div className="container">
    <Text field={fields.Text} tag="h2" className="title" />
  </div>
);

export default SectionHeader;
