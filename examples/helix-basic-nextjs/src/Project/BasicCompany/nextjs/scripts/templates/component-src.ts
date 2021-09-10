/**
 * Generates React boilerplate for a component under `src/components`
 * @param componentName - the component name
 * @returns component src boilerplate as a string
 */
function generateComponentSrc(componentName: string): string {
  return `import { Text, Field } from '@sitecore-jss/sitecore-jss-nextjs';

type ${componentName}Props = {
  fields: {
    heading: Field<string>;
  };
};

const ${componentName} = (props: ${componentName}Props): JSX.Element => (
  <div>
    <p>${componentName} Component</p>
    <Text field={props.fields.heading} />
  </div>
);

export default ${componentName};
`;
}

export default generateComponentSrc;
