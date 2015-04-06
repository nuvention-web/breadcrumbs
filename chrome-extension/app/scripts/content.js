'use strict';

chrome.extension.onRequest.addListener(function(request, sender, callback) {
  if (request.method === 'getHTML') {
    var response = {};
    response.data = document.getElementsByTagName('html')[0].innerHTML;
    callback(response);
  }
});