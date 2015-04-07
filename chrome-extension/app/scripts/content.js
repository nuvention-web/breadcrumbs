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

    callback(response);
  }
});