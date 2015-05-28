'use strict';

/* WHEN MAKING A NEW SITE:

  Mandatory fields:
    response.price = 'PRICE'
    response.site = 'SITENAME'

  e.g. This would count as valid but totally suck.

  case 'example.example:':
    response.price
    response.site = 'Example'
    break;
*/ 


chrome.extension.onRequest.addListener(function(request, sender, callback) {
  if (request.method === 'getAndParseHtml') {
    debugger;
    var response = request.page;

    //ignore function for ebay's title issue
    $.fn.ignore = function(sel){
        return this.clone().find(sel||">*").remove().end();
    };

    switch(request.page.site) {
      case 'amazon.com':
        console.log ('Amazon page detected.');
        var name = $('#productTitle').text();
        if (!name) {
            break;
        }
        var brand = $('#brand').text();
        var price = $('#priceblock_ourprice').text();
        if (!price) {
          price = $('#priceblock_saleprice').text();
        }
        var main_image = $('#main-image-container').find('img').attr('src');

        var rating_text = $('#acrPopover').attr('title');
        var rating = rating_text.split(' ')[0];

        var breadcrumbs = $('#wayfinding-breadcrumbs_container').find('a');
        var web_taxonomy = [];
        for(var i=0; i < breadcrumbs.length; i++) {
          if (breadcrumbs[i].innerText) {
            web_taxonomy.push(breadcrumbs[i].innerText);
          }
        }

        try {
          if (web_taxonomy.length === 0 || web_taxonomy[0].indexOf('Back to search results') !== -1) {
            breadcrumbs = $('#browse_feature_div').find('a');
            web_taxonomy = [];
            for(i=0; i < breadcrumbs.length; i++) {
              if (breadcrumbs[i].innerText) {
                web_taxonomy.push(breadcrumbs[i].innerText);
              }
            }
          }
        }
        catch (err) {
          // do nothing
        }

        try {
          if (web_taxonomy.length === 0 || web_taxonomy[0].indexOf('Back to search results') !== -1) {
            breadcrumbs = $('.zg_hrsr_ladder').first().find('a');
            web_taxonomy = [];
            for(i=0; i < breadcrumbs.length; i++) {
              if (breadcrumbs[i].innerText) {
                web_taxonomy.push(breadcrumbs[i].innerText);
              }
            }
          }
        }
        catch (err) {
          // do nothing
        }

        // fallback
        try {
          if (web_taxonomy.length === 0 || web_taxonomy[0].indexOf('Back to search results') !== -1) {
            breadcrumbs = $('meta[name=title]').attr('content');
            breadcrumbs = breadcrumbs.split(': ');
            web_taxonomy = [breadcrumbs[breadcrumbs.length - 1]];
          }
        }
        catch (err) {
          // do nothing!
        }

        if ($('body').hasClass('book')) {
          web_taxonomy = ['Books'];
          var price_elements = $('#tmmSwatches').find('.a-color-secondary');
          if (price_elements) {
              price = $(price_elements[0]).children()[0].innerText;
          }
        }

        if ($('body').hasClass('amazon_tablets')) {
          web_taxonomy = ['Tablets'];
        }

        if ($('body').hasClass('amazon_ereaders')) {
          web_taxonomy = ['E-Readers'];
        }

        response.name = name;
        response.brand = brand;
        response.price = price;
        response.main_image = main_image;
        response.rating = rating;
        response.web_taxonomy = web_taxonomy;

        var details  = $('#descriptionAndDetails').find('.a-text-bold');
        for(i=0; i < details.length; i++) {
          if (!details[i].innerText) {
            continue;
          }

          if (details[i].innerText.toLowerCase().indexOf('asin') !== -1) {
            response.asin = $(details[i]).next()[0].innerText;
          }
          else if (details[i].innerText.toLowerCase().indexOf('model number') !== -1) {
            response.model = $(details[i]).next()[0].innerText;
          }
        }

        var description_node = $('#productDescription').find('p');
        var description = []
        for(i=0; i < description_node.length; i++) {
          description.push(description_node[i].innerText);
        }
        response.description = description;

        response.site = 'Amazon'

        // var features_bullets = $('#feature-bullets').find('li');
        // var features = [];
        // var text;
        // for(i in features_bullets) {
        //   text = $(features_bullets[i]).children().text();
        //   features.push(text);
        // }
        // response.features = features;
        break;

      case 'ebay.com':
        // Ebay: Note that this is for individual items within eBay that are BUY IT NOW
        var name = $("#itemTitle").ignore('span').text();
        var price = $("#prcIsum").text();
        var brand = $(".itemAttr").find("h2[itemprop='brand']").text();
        var category = $("gh-cat option:selected").text();
        if (category == ""){
            category = $(".scnd").text();
        }
        var web_taxonomy = [];
        $("#vi-VR-brumb-lnkLst li").each(function(){
            if($(this).find('a').text() != '' && $(this).find('a').text().indexOf('Back to search') === -1){
                web_taxonomy.push($(this).find('a').text()); //iterate through even items in array to get names
            }
        })
        var tax_counter = 0;

        var model = $(".itemAttr").find("h2[itemprop='model']").text();
        var main_image = $("#icImg").attr("src");
        var all_images = [];
        $("#vi_main_img_fs_slider li").each(function(){
            all_images.push($(this).find('img').attr("src"));
        });
        var description = $("#desc_ifr").attr("src");

        response.name = name;
        response.price = price;
        response.brand = brand;
        response.web_taxonomy = web_taxonomy;
        response.model = model;
        response.main_image = main_image;
        response.all_images = all_images;
        response.description = description;

        response.site = 'ebay'
        break;

      case 'store.nike.com':
        var name = $('.exp-product-title').text();
        var price = $('.exp-pdp-local-price').first().text();
        var brand = 'Nike';
        var category = 'Clothing, Shoes & Jewelry';
        var web_taxonomy = [category, $('.exp-product-subtitle').text()];
        var model = '';
        var main_image = $('.exp-pdp-hero-image').attr('src');
        var all_images = [];
        $('.exp-pdp-alt-images-carousel li').each(function(){
            all_images.push($(this).find('img').attr('src'));
        });
        var description = $('.colorText').text();

        response.name = name;
        response.price = price;
        response.brand = brand;
        response.web_taxonomy = web_taxonomy;
        response.model = model;
        response.main_image = main_image;
        response.all_images = all_images;
        response.description = description;

        response.site = 'Nike Store'
        break;

      case 'express.com':
        var name = $('[itemprop=name]').first().text();
        var price = $('[itemprop=price]').first().text();
        var brand = 'Express';
        var category = 'Clothing, Shoes & Jewelry';
        var web_taxonomy = [category]; // this is somewhat lacking right now...
        var model = ''
        var main_image = $('#product-detail-flyout-container').find('img').first().attr('data-src');
        if (main_image[0] = '/') {
          main_image = 'http' + main_image;
        }
        var colors = []
        $('#express-view-colors li label').each(function() {
          colors.push($(this).attr('title'));
        })
        var description = $('.product-description p').text();

        response.name = name;
        response.price = price;
        response.brand = brand;
        response.web_taxonomy = web_taxonomy;
        response.model = model;
        response.main_image = main_image;
        response.colors = colors;
        response.description = description;

        response.site = 'Express'
        break;




      // case 'ruvilla.com':
      //   var name = $(".product-name").ignore('span').text();
      //   var price = $(".price").text();
      //   var brand = $(".brand")text();
      //   var category = $("gh-cat option:selected").text();
      //   if (category == ""){
      //       category = $(".scnd").text();
      //   }
      //   var web_taxonomy = [];
      //   $("#vi-VR-brumb-lnkLst li").each(function(){
      //       if($(this).find('a').text() != '' && $(this).find('a').text().indexOf('Back to search') === -1){
      //           web_taxonomy.push($(this).find('a').text()); //iterate through even items in array to get names
      //       }
      //   })
      //   var tax_counter = 0;

      //   var model = $(".itemAttr").find("h2[itemprop='model']").text();
      //   var main_image = $(".MagicZoomPlus").attr("href");
      //   var all_images = [];
      //   $("#vi_main_img_fs_slider li").each(function(){
      //       all_images.push($(this).find('img').attr("src"));
      //   });
      //   var description = $("#desc_ifr").attr("src");

      //   response.name = name;
      //   response.price = price;
      //   response.brand = brand;
      //   response.web_taxonomy = web_taxonomy;
      //   response.model = model;
      //   response.main_image = main_image;
      //   response.all_images = all_images;
      //   response.description = description;
      //   console.log(name + price);
      //   break;

      default:
        break;
        
    }



    callback(response);
  }
});

function clothingClassifier(name) {

}