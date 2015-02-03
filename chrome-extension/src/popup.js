// LOOK INTO CONTENT SCRIPTS

// var path = "http://breadcrumbs.meteor.com/datapost";
var path = "http://localhost:3000/datapost";


//example of using a message handler from the inject scripts
chrome.webNavigation.onDOMContentLoaded.addListener(
  function(details) {
    console.log(details);
    // post({hello: 'world'});
  });

function post(params) {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.open("POST", path, true);

  //Send the proper header information along with the request
  xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xmlhttp.setRequestHeader("Content-length", params.length);
  xmlhttp.setRequestHeader("Connection", "close");

  xmlhttp.onreadystatechange = function() {
      if(xmlhttp.readyState == 4 && xmlhttp.status == 200) {
          alert(xmlhttp.responseText);
      }
  };
  xmlhttp.send(JSON.stringify(params));
}