import React, { createContext, useContext, ReactNode } from 'react';
import { NavigationQuery } from './Navigation.graphql';

export const NavigationDataReactContext = createContext<NavigationQuery>({});

export function useNavigationData(): NavigationQuery {
  return useContext(NavigationDataReactContext);
}

export type NavigationDataContextProps = {
  children: ReactNode;
  value: NavigationQuery;
};

export const NavigationDataContext = ({
  children,
  value,
}: NavigationDataContextProps): JSX.Element => (
  <NavigationDataReactContext.Provider value={value}>
    {children}
  </NavigationDataReactContext.Provider>
);
