'use strict';

/* POST REQUEST SETUP */
var domain = 'http://localhost:3000';
// var domain = 'http://breadcrumbs.meteor.com'
var path = domain + '/datapost';
var tabStore = {};

/* HTML PARSER SETUP */
// console.log(Tautologistics.NodeHtmlParser);
// var handler = new Tautologistics.NodeHtmlParser.DefaultHandler(function (error, dom) {
//   if (error)
//     console.log(error);
//   else
//     console.log(dom);
// });

/* CROSS-DOMAIN POST TO SERVER */
function post(params) {
  console.log('ATTEMPTING POST');
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
              console.log('success!');
              break;
            default:
              console.log('fuck...');
          }
        },
        error: function (xhr, ajaxOptions, thrownError) {
          console.log(xhr.status);
          console.log('server is probably unavailable');
          console.log(ajaxOptions);
          console.log(thrownError);
          // alert(xhr.status);
          // alert(thrownError);
        }
      });
    }
    else {
      console.log('Rejected Post. No ID');
    }
  });
}

chrome.tabs.onUpdated.addListener(
  function(tabID, changeInfo, tab) {
    if (tabStore[tabID] === undefined) {
      tabStore[tabID] = tab;
    }
    if (changeInfo.url !== undefined) {
      if (tabStore[tabID].previous) {
        tabStore[tabID].previous.close = new Date().getTime();
        post(tabStore[tabID].previous);
        delete tabStore[tabID].previous;
      }
    //   var newPage = {};
    //   newPage.url = changeInfo.url;
    //   newPage.start = new Date().getTime();

    //   if (tabStore[tabID].previous === undefined) {
    //     newPage.from = '';
    //     tabStore[tabID].previous = newPage;
    //   }
    //   else {
    //     newPage.from = tabStore[tabID].previous.url;
    //     tabStore[tabID].previous.end = newPage.start;
    //     post(tabStore[tabID].previous);
    //     tabStore[tabID].previous = newPage;
    //   }
    }
    // second iteration of tab loaded
    if (changeInfo.status === 'complete' && tab.url.substring(0, 6) !== 'chrome') {
      // tabStore[tabID].previous.title = tab.title;
      // tabStore[tabID].previous.favIcon = tab.favIconUrl;

      var newPage = {};
      newPage.page_title = tab.title;
      newPage.favIcon = tab.favIconUrl;
      newPage.url = tab.url;
      newPage.open = new Date().getTime();

      var site = '';
      var bracketCount = 0;
      for(var ch in tab.url) {
        if (site === 'www.') {
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

      chrome.tabs.sendRequest(tabID, {method: 'getAndParseHtml', page: newPage}, function (res) {
        if (res && res.price) {
          tabStore[tabID].previous = res;
        }
      });
    }
  });

chrome.tabs.onRemoved.addListener(
  function(tabID) {
    tabStore[tabID].previous.end = new Date().getTime();
    post(tabStore[tabID].previous);
    delete tabStore[tabID];
  });