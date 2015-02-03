var path = "http://breadcrumbs.meteor.com/datapost";
// var path = "http://localhost:3000/datapost";

$( document ).ready(function() {
  params = {};
  params.from = document.referrer;
  params.url = window.location.href;
  params.time = [(new Date()).getTime()];

  window.onbeforeunload = function() {
    params.time.push((new Date()).getTime());
    post(params);
  };
});

// We get XSS warnings from sites like facebook.
function post(params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
         }
    }

    document.body.appendChild(form);
    form.submit();
}

// function post(params) {
//   var xmlhttp = new XMLHttpRequest();
//   xmlhttp.open("POST", path, true);

//   //Send the proper header information along with the request
//   // xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
//   // xmlhttp.setRequestHeader("Content-length", params.length);
//   // xmlhttp.setRequestHeader("Connection", "close");

//   xmlhttp.onreadystatechange = function() {
//       if(xmlhttp.readyState == 4 && xmlhttp.status == 200) {
//           alert(xmlhttp.responseText);
//       }
//   };
//   console.log(params);
//   xmlhttp.send(params);
// }