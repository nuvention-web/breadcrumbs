'use strict';

chrome.extension.onRequest.addListener(function(request, sender, callback) {
  if (request.method === 'getAndParseHtml') {
    debugger;
    var response = {};
    response.debug = [];
    response.item = {};

    response.debug.push('example debug message here.');
    var title = $('#productTitle');
    var stuff = $('span');

    // DO ALL WORK HERE

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

    response.item.title = title;
    response.item.price = price;
    response.item.brand = brand;
    response.item.web_taxonomy = web_taxonomy;
    response.item.model = model;
    response.item.main_image = main_image;
    response.item.all_images = all_images;
    response.item.description = description;



    callback(response);
  }
});