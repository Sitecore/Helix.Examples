const path = require('path');

module.exports = {
  webpackFinal: async (baseConfig, options) => {
    const { module = {} } = baseConfig;
    
    const newConfig = {
      ...baseConfig,
      module: {
        ...module,
        rules: [...(module.rules || [])],
      },
    };

    newConfig.resolve.modules = [
      path.resolve(__dirname, "../src"),
      "node_modules",
    ]

    // TypeScript 
    newConfig.module.rules.push({
      test: /\.(ts|tsx)$/,
      include: [path.resolve(__dirname, '../src/components')],
      use: [
        {
          loader: 'babel-loader',
          options: {
            presets: ['next/babel', require.resolve('babel-preset-react-app')],
            plugins: ['react-docgen'],
          },
        },
      ],
    });
    newConfig.resolve.extensions.push('.ts', '.tsx');

    newConfig.module.rules.push({ 
      test: /\.graphql$/,
      exclude: /node_modules/,
      use: [
        { loader: 'babel-loader', options: { presets: ['@babel/preset-typescript', '@babel/preset-react'] } },
        { loader: 'graphql-let/loader' },
      ]
    });
    newConfig.resolve.extensions.push('.graphql');

    return newConfig;
  },
};