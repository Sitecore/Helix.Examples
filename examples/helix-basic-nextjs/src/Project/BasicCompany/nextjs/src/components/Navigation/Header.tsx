import {
  GetStaticComponentProps,
  useComponentProps,
  ComponentRendering,
} from '@sitecore-jss/sitecore-jss-nextjs';
import GraphQLClientFactory from 'lib/GraphQLClientFactory';
import React, { ComponentProps } from 'react';
import { NavigationDocument, NavigationQuery, _NavigationItem, Item } from './Header.graphql';
import NextLink from 'next/link';

const navigationItemTemplateId = 'c231fbb4dcdb470899bc94760f222cc5';

type HeaderProps = {
  rendering: ComponentRendering;
};

type NavItem = _NavigationItem & Item;

const Header = ({ rendering }: HeaderProps): JSX.Element => {
  const data = rendering.uid ? useComponentProps<NavigationQuery>(rendering.uid) : undefined;

  return (
    <nav className="navbar is-black is-tab" role="navigation" aria-label="main navigation">
      <div className="container">
        <div className="navbar-brand">
          <a className="navbar-item" href="/">
            <img asp-for="LogoLink.HeaderLogo" />
          </a>

          <a
            role="button"
            className="navbar-burger burger"
            aria-label="menu"
            aria-expanded="false"
            data-target="navbarBasicExample"
          >
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
          </a>
        </div>

        <div id="navbarBasicExample" className="navbar-menu">
          <div className="navbar-start">
            {data &&
              data.search?.results.map((item, index) => {
                const navItem = item as NavItem;
                return (
                  <NextLink key={index} href={navItem?.url.path}>
                    <a className="navbar-item is-tab">{navItem.navigationTitle?.value.value}</a>
                  </NextLink>
                );
              })}
          </div>
        </div>
      </div>
    </nav>
  );
};

export const getStaticProps: GetStaticComponentProps = async (rendering) => {
  const rootId = rendering?.fields?.rootId;
  if (!rootId) {
    return null;
  }

  const graphQLClient = GraphQLClientFactory();

  const result = await graphQLClient.query<NavigationQuery>({
    query: NavigationDocument,
    variables: {
      siteRoot: rootId,
      templateId: navigationItemTemplateId,
    },
  });

  return result.data;
};

export default Header;
