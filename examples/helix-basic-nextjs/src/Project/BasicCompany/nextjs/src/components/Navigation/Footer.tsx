import React from 'react';
import { HomePage } from './Navigation.graphql';
import { useNavigationData } from './NavigationDataContext';

const Footer = (): JSX.Element => {
  const data = useNavigationData();
  const homeItem = data?.item as HomePage;

  return (
    <footer className="footer footer-extended">
      <div className="content container">
        <p>
          {homeItem.footerCopyright?.value} &copy; 2018-{new Date().getFullYear()}
        </p>
      </div>
    </footer>
  );
};

export default Footer;
