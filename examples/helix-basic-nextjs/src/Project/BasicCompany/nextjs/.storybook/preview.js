import '../src/assets/basic-company.css';
import React from "react"; 
import { RouterContext } from  'next/dist/next-server/lib/router-context';  

export const parameters = {
  actions: { argTypesRegex: "^on[A-Z].*" },
}

// mock the Next router so we can output links without error
// https://github.com/vercel/next.js/issues/16864#issuecomment-743743089
export const decorators = [
  (Story) => (
    <RouterContext.Provider value={{
      push: () => Promise.resolve(),
      replace: () => Promise.resolve(),
      prefetch: () => Promise.resolve()
    }}>  
      <Story />
    </RouterContext.Provider>
  ),
];