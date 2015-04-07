'use strict';

chrome.extension.onRequest.addListener(function(request, sender, callback) {
  if (request.method === 'getAndParseHtml') {
    debugger;
    var response = {};
    response.debug = [];
    response.item = {};

    // AMAZON
    switch(request.site) {
      case 'amazon.com':
        response.debug.push('Amazon.com detected.');
        var name = $('#productTitle').text();
        var brand = $('#brand').text();
        var price = $('#priceblock_ourprice').text();
        var main_image = $('#main-image-container').find('img').attr('src');

        var rating_text = $('#avgRating').children().text();
        var rating = rating_text.split(' ')[0];

        var breadcrumbs = $('#wayfinding-breadcrumbs_container').find('a');
        var web_taxonomy = [];
        for(var i=0; i < breadcrumbs.length; i++) {
          if (breadcrumbs[i].innerText) {
            web_taxonomy.push(breadcrumbs[i].innerText);
          }
        }
        
        response.item.name = name;
        response.item.brand = brand;
        response.item.price = price;
        response.item.main_image = main_image;
        response.item.rating = rating;
        response.item.web_taxonomy = web_taxonomy;

        var details  = $('#descriptionAndDetails').find('.a-text-bold');
        for(i=0; i < details.length; i++) {
          if (!details[i].innerText) {
            continue;
          }

          if (details[i].innerText.toLowerCase().indexOf('asin') !== -1) {
            response.item.asin = $(details[i]).next()[0].innerText;
          }
          else if (details[i].innerText.toLowerCase().indexOf('model number') !== -1) {
            response.item.model = $(details[i]).next()[0].innerText;
          }
        }

        var description_node = $('#productDescription').find('p');
        var description = []
        for(i=0; i < description_node.length; i++) {
          description.push(description_node[i].innerText);
        }
        response.item.description = description;

        // var features_bullets = $('#feature-bullets').find('li');
        // var features = [];
        // var text;
        // for(i in features_bullets) {
        //   text = $(features_bullets[i]).children().text();
        //   features.push(text);
        // }
        // response.item.features = features;
        break;

      default:
        response.debug.push('No data tracked');
        break;
        
    }
    
    // DO ALL WORK HERE

    callback(response);
  }
});