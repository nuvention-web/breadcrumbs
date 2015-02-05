var path = "http://breadcrumbs.meteor.com/datapost";
// var path = "http://localhost:3000/datapost";
var tabStore = {};

chrome.tabs.onUpdated.addListener(
  function(tabID, changeInfo, tab) {
    console.log(changeInfo.url);
    if (tabStore[tabID] === undefined) {
      tabStore[tabID] = tab;
    }
    if (changeInfo.url !== undefined &&
        changeInfo.url.substring(0, 6) !== 'chrome') {

      var newPage = {};
      newPage.url = changeInfo.url;
      newPage.start = new Date().getTime();

      if (tabStore[tabID].previous === undefined) {
        newPage.from = '';
        tabStore[tabID].previous = newPage;
      }
      else {
        newPage.from = tabStore[tabID].previous.url;
        tabStore[tabID].previous.end = newPage.start;
        post(tabStore[tabID].previous);
        tabStore[tabID].previous = newPage;
      }
    }
    // second iteration of tab loaded
    if (changeInfo.status == 'complete') {
      tabStore[tabID].previous.title = tab.title;
      tabStore[tabID].previous.favIcon = tab.favIconUrl;
    }
  });

chrome.tabs.onRemoved.addListener(
  function(tabID) {
    tabStore[tabID].previous.end = new Date().getTime();
    post(tabStore[tabID].previous);
    delete tabStore[tabID];
  });

function post(params) {
  $.ajax({
          url: path,
          type: "POST",
          data: params,
          dataType: "json",
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
            // alert(xhr.status);
            // alert(thrownError);
          }
      });
}