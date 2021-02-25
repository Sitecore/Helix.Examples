import React from 'react';
import { _NavigationItem, Item, HomePage } from './Navigation.graphql';
import { useNavigationData } from './NavigationDataContext';
import NextLink from 'next/link';

type NavItem = _NavigationItem & Item;

const Header = (): JSX.Element => {
  const data = useNavigationData();
  const items = [data?.item, ...(data?.item?.children as NavItem[])];
  const homeItem = data?.item as HomePage;

  return (
    <nav className="navbar is-black is-tab" role="navigation" aria-label="main navigation">
      <div className="container">
        <div className="navbar-brand">
          {homeItem && (
            <a className="navbar-item" href={homeItem.url.path}>
              <img
                src={homeItem.headerLogo?.src || ''}
                alt={homeItem.navigationTitle?.value || 'Home'}
              />
            </a>
          )}

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
            {items &&
              items?.map((item, index) => {
                const navItem = item as NavItem;
                return (
                  <NextLink key={index} href={navItem?.url.path}>
                    <a className="navbar-item is-tab">{navItem?.navigationTitle?.value}</a>
                  </NextLink>
                );
              })}
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Header;
