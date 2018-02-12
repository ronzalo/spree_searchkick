// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/frontend/all.js'
//= require_tree .

Spree.typeaheadSearch = function() {
  var products = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    prefetch: Spree.pathFor('autocomplete/products.json'),
    remote: {
      url: Spree.pathFor('autocomplete/products.json?keywords=%25QUERY'),
      wildcard: '%QUERY'
    }
  });

  products.initialize();

  // passing in `null` for the `options` arguments will result in the default
  // options being used
  $('#keywords').typeahead({
    minLength: 2,
    highlight: true
  }, {
      name: 'products',
      source: products
    });
}