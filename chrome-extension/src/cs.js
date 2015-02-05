var path = "http://breadcrumbs.meteor.com/datapost";
// var path = "http://localhost:3000/datapost";

$( document ).ready(function() {
  params = {};
  params.from = document.referrer;
  params.url = window.location.href;
  post(params);
  // params.time = [(new Date()).getTime()];

  // window.onbeforeunload = function() {
  //   params.time.push((new Date()).getTime());
  //   post(params);
  // };
  // $(window).bind('beforeunload', function() {
  //   params.time.push((new Date()).getTime());
  //   post(params);
  // });
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
                      processResponse(result);
                      break;
                  default:
                      resultDiv.html(result);
              }
          },
          error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(thrownError);
          }
      });
}