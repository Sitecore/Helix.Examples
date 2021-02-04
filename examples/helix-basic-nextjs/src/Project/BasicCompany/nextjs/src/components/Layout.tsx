import Head from 'next/head';
import { getPublicUrl } from 'lib/util';
import { Placeholder, RouteData, VisitorIdentification } from '@sitecore-jss/sitecore-jss-nextjs';

// Prefix public assets with a public URL to enable compaitibility with Sitecore Experience Editor.
// If you're not supporting the Experience Editor, you can remove this.
const publicUrl = getPublicUrl();

type LayoutProps = {
  route: RouteData;
};

const Layout = ({ route }: LayoutProps): JSX.Element => {
  return (
    <>
      <Head>
        <title>
          {(route.fields && route.fields.pageTitle && route.fields.pageTitle.value) || 'Page'}
        </title>
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
      <div className="container">
        <Placeholder name="header" rendering={route} />
        <Placeholder name="main" rendering={route} />
        <Placeholder name="footer" rendering={route} />
      </div>
    </>
  );
};

export default Layout;
