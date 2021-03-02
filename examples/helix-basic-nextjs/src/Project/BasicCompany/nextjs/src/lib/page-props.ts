import {
  DictionaryPhrases,
  LayoutServiceData,
  ComponentPropsCollection,
  RouteData,
  LayoutServiceContext,
} from '@sitecore-jss/sitecore-jss-nextjs';
import { NavigationQuery } from 'components/Navigation/Navigation.graphql';

export type SitecorePageProps = {
  locale: string;
  layoutData: LayoutServiceData | null;
  dictionary: DictionaryPhrases;
  componentProps: ComponentPropsCollection;
  navigation: NavigationQuery;
  notFound: boolean;
};

export type SitecoreContextValues = LayoutServiceContext & {
  route: RouteData | undefined;
  itemId: string | undefined;
};
