'use strict';

chrome.extension.onRequest.addListener(function(request, sender, callback) {
  if (request.method === 'getAndParseHtml') {
    // debugger;
    var response = request.page;

    //ignore function for ebay's title issue
    $.fn.ignore = function(sel){
        return this.clone().find(sel||">*").remove().end();
    };

    // AMAZON
    switch(request.page.site) {
      case 'amazon.com':
        console.log ('amazon')
        var name = $('#productTitle').text();
        if (!name) {
            break;
        }
        var brand = $('#brand').text();
        var price = $('#priceblock_ourprice').text();
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
        break;

      // case 'ruvilla.com':
      //   var name = $(".product-name").ignore('span').text();
      //   var price = $(".price").text();
      //   var brand = $(".brand")text();
      //   // var category = $("gh-cat option:selected").text();
      //   // if (category == ""){
      //   //     category = $(".scnd").text();
      //   // }
      //   // var web_taxonomy = [];
      //   // $("#vi-VR-brumb-lnkLst li").each(function(){
      //   //     if($(this).find('a').text() != '' && $(this).find('a').text().indexOf('Back to search') === -1){
      //   //         web_taxonomy.push($(this).find('a').text()); //iterate through even items in array to get names
      //   //     }
      //   // })
      //   var tax_counter = 0;

      //   // var model = $(".itemAttr").find("h2[itemprop='model']").text();
      //   var main_image = $(".MagicZoomPlus").attr("href");
      //   // var all_images = [];
      //   // $("#vi_main_img_fs_slider li").each(function(){
      //   //     all_images.push($(this).find('img').attr("src"));
      //   // });
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