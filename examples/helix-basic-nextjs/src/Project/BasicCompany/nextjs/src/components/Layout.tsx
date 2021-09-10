import Head from 'next/head';
import { getPublicUrl } from 'lib/util';
import {
  LayoutServiceData,
  Placeholder,
  useSitecoreContext,
  VisitorIdentification,
} from '@sitecore-jss/sitecore-jss-nextjs';
import { useEffect } from 'react';
import { SitecoreContextValues } from 'lib/page-props';

// Prefix public assets with a public URL to enable compatibility with Sitecore Experience Editor.
// If you're not supporting the Experience Editor, you can remove this.
const publicUrl = getPublicUrl();

type LayoutProps = {
  layoutData: LayoutServiceData;
};

const Layout = ({ layoutData }: LayoutProps): JSX.Element => {
  const { updateSitecoreContext } = useSitecoreContext({ updatable: true });

  // Update Sitecore Context if layoutData has changed (i.e. on client-side route change).
  // Note the context object type here matches the initial value in [[...path]].tsx.
  useEffect(() => {
    const context: SitecoreContextValues = {
      route: layoutData.sitecore.route,
      itemId: layoutData.sitecore.route.itemId,
      ...layoutData.sitecore.context,
    };
    updateSitecoreContext && updateSitecoreContext(context);
  }, [layoutData]);

  const { route } = layoutData.sitecore;

  return (
    <>
      <Head>
        <title>{route.fields?.NavigationTitle?.value || 'Page'}</title>
        <link rel="icon" href={`${publicUrl}/favicon.ico`} />
      </Head>

      {/*
        VisitorIdentification is necessary for Sitecore Analytics to determine if the visitor is a robot.
        If Sitecore XP (with xConnect/xDB) is used, this is required or else analytics will not be collected for the JSS app.
        For XM (CMS-only) apps, this should be removed.

        VI detection only runs once for a given analytics ID, so this is not a recurring operation once cookies are established.
      */}
      <VisitorIdentification />

      {/* root placeholder for the app, which we add components to using route data */}
      <Placeholder name="header" rendering={route} />
      <Placeholder name="main" rendering={route} />
      <Placeholder name="footer" rendering={route} />
    </>
  );
};

export default Layout;
