import {
  DictionaryPhrases,
  LayoutServiceData,
  ComponentPropsCollection,
} from '@sitecore-jss/sitecore-jss-nextjs';
import { NavigationQuery } from 'components/Navigation/Navigation.graphql';

export type SitecorePageProps = {
  locale: string;
  layoutData: LayoutServiceData;
  dictionary: DictionaryPhrases;
  componentProps: ComponentPropsCollection;
  navigation: NavigationQuery;
  notFound: boolean;
};
