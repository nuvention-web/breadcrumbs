'use strict';

chrome.extension.onRequest.addListener(function(request, sender, callback) {
  if (request.method === 'getAndParseHtml') {
    debugger;
    var response = request.page;

    // AMAZON
    switch(request.page.site) {
      case 'amazon.com':
        var name = $('#productTitle').text();
        if (!name) {
            break;
        }
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
        var title = $("#itemTitle").text();
        var price = $("#prcIsum").text();
        var brand = $(".itemAttr").find("h2[itemprop='brand']").text();
        var category = $("gh-cat option:selected").text();
        if (category == ""){
            category = $(".scnd").text();
        }
        var web_taxonomy = [];
        $("#vi-VR-brumb-lnkLst li").each(function(){
            web_taxonomy.push($(this).find('a').text()); //iterate through even items in array to get names
        })
        var tax_counter = 0;
        for(var i = 0; i < web_taxonomy.length; i+=2){
            web_taxonomy[tax_counter] = web_taxonomy[i];
            tax_counter++;
        }
        var model = $(".itemAttr").find("h2[itemprop='model']").text();
        var main_image = $("#icImg").attr("src");
        var all_images = [];
        $("#vi_main_img_fs_slider li").each(function(){
            all_images.push($(this).find('img').attr("src"));
        });
        var description = $("#desc_ifr").attr("src");

        response.title = title;
        response.price = price;
        response.brand = brand;
        response.web_taxonomy = web_taxonomy;
        response.model = model;
        response.main_image = main_image;
        response.all_images = all_images;
        response.description = description;
        break;

      default:
        break;
        
    }



    callback(response);
  }
});