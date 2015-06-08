'use strict';

// Set domain for either testing or deployment.
var domain = 'http://localhost:3000';
// var domain = 'http://breadcrumbs.ninja';
var path = domain + '/datapost';
var tabStore = {};

// Ajax POST request to server containing item information.
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
              // console.log('Post was successful.');
              break;
            default:
              // console.log('Post was unsuccessful.');
              // console.log(result);
          }
        },
        error: function (xhr, ajaxOptions, thrownError) {
          console.log('An error was thrown. The server\'s probably unavailable.');
          // console.log('XHR Object: ');
          // console.log(xhr);
          // console.log('AjaxOptions: ');
          // console.log(ajaxOptions);
          // console.log('Thrown Error: ');
          // console.log(thrownError);
        }
      });
    }
    else {
      console.log('Post attempt rejected. No userID currently active.');
    }
  });
}

// Catches each navigation change and sends command to content
// script to parse page and POST data to server.
chrome.tabs.onUpdated.addListener(
  function(tabID, changeInfo, tab) {
    if (tabStore[tabID] === undefined) {
      tabStore[tabID] = tab;
    }
    // On navigation to a new URL
    if (changeInfo.url !== undefined) {
      if (tabStore[tabID].previous) {
        tabStore[tabID].previous.close = new Date().getTime();
        post(tabStore[tabID].previous);
        delete tabStore[tabID].previous;
      }

      // Create an alert to remind user to log into extension on email verification
      if (changeInfo.url.match(new RegExp('https?://breadcrumbs.ninja/#/verify-email/.*'))) {
        chrome.storage.local.get('breadcrumbsID', function(items) {
          if (!items.breadcrumbsID || items.breadcrumbsID === 0) {
            chrome.notifications.create(undefined, {'type': 'basic', 'title': 'Please be sure to login to the extension!', 'message': 'Click the extension icon and enter your username and password.', iconUrl: '../images/96.png'});
          }
        });
      }
    }
    // On tab fully loaded. Collect some data and send to content script for full parsing.
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

      // console.log('The tab has been loaded. Parsing...');
      chrome.tabs.sendRequest(tabID, {method: 'getAndParseHtml', page: newPage}, function (res) {
        if (res && res.price) {
          // console.log('Parsing complete.');
          tabStore[tabID].previous = res;
          res.close = res.open;
          post(res);
        }
      });
    }
  });

// Two-fold POST: once on load and once on exiting page
// to log time spent on page.
chrome.tabs.onRemoved.addListener(
  function(tabID) {
    if (tabStore[tabID] && tabStore[tabID].previous) {
      tabStore[tabID].previous.close = new Date().getTime();
      post(tabStore[tabID].previous);
      delete tabStore[tabID];
    }
  });