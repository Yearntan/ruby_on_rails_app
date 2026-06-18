const { generateWebpackConfig, merge } = require('shakapacker');
const webpack = require('webpack'); // You need to require webpack like this

const options = {
  resolve: {
    extensions: ['.css', '.scss']
  },
  plugins: [ // Make sure plugins is inside the options object
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery'
    }),
  ]
}

module.exports = merge({}, generateWebpackConfig(), options);
