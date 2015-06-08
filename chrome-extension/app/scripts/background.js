'use strict';

// post request setup
var domain = 'http://localhost:3000';
// var domain = 'http://breadcrumbs.ninja';
var path = domain + '/datapost';
var tabStore = {};

// cross-domain post to server
function post(params) {
  console.log('Making post request...');
  console.log(params);
  chrome.storage.local.get('breadcrumbsID', function(items) {
    if (items.breadcrumbsID && items.breadcrumbsID !== 0) {
      params.uid = items.breadcrumbsID;
      $.ajax({
        url: path,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function (result) {
          switch (result) {
            case true:
              console.log('Post was successful.');
              break;
            default:
              console.log('Post was unsuccessful.');
              console.log(result);
          }
        },
        error: function (xhr, ajaxOptions, thrownError) {
          console.log('An error was thrown. The server\'s probably unavailable.');
          console.log('XHR Object: ');
          console.log(xhr);
          console.log('AjaxOptions: ');
          console.log(ajaxOptions);
          console.log('Thrown Error: ');
          console.log(thrownError);
        }
      });
    }
    else {
      console.log('Post attempt rejected. No userID currently active.');
    }
  });
}

var flag = false;

chrome.tabs.onUpdated.addListener(
  function(tabID, changeInfo, tab) {
    if (tabStore[tabID] === undefined) {
      tabStore[tabID] = tab;
    }
    // navigating to different url
    if (changeInfo.url !== undefined) {
      if (tabStore[tabID].previous) {
        tabStore[tabID].previous.close = new Date().getTime();
        post(tabStore[tabID].previous);
        delete tabStore[tabID].previous;
      }

      if (changeInfo.url.match(new RegExp('https?://breadcrumbs.ninja/#/verify-email/.*'))) {
        chrome.storage.local.get('breadcrumbsID', function(items) {
          if (!items.breadcrumbsID || items.breadcrumbsID === 0) {
            chrome.notifications.create(undefined, {'type': 'basic', 'title': 'Please be sure to login to the extension!', 'message': 'Click the extension icon and enter your username and password.', iconUrl: '../images/96.png'});
          }
        });
      }
    }
    // second iteration of tab loaded
    if (changeInfo.status === 'complete' && tab.url.substring(0, 6) !== 'chrome') {
      var newPage = {};
      newPage.page_title = tab.title;
      newPage.favIcon = tab.favIconUrl;
      newPage.url = tab.url;
      newPage.open = new Date().getTime();

      var site = '';
      var bracketCount = 0;
      for(var ch in tab.url) {
        if (site === 'www.' || site === 'www1.') {
          site = '';
        }
        if (tab.url[ch] === '/') {
          bracketCount++;
        }
        else if (bracketCount === 2) {
          site += tab.url[ch];
        }
      }
      newPage.site = site;
      console.log(tab);

      console.log('The tab has been loaded. Parsing...');

      chrome.tabs.sendRequest(tabID, {method: 'getAndParseHtml', page: newPage}, function (res) {
        if (res && res.price) {
          console.log('Parsing complete.');
          tabStore[tabID].previous = res;
          res.close = res.open;
          post(res);
        }
      });
    }
  });

chrome.tabs.onRemoved.addListener(
  function(tabID) {
    if (tabStore[tabID] && tabStore[tabID].previous) {
      tabStore[tabID].previous.close = new Date().getTime();
      post(tabStore[tabID].previous);
      delete tabStore[tabID];
    }
  });