'use strict';

var id;

var ceres = new Asteroid('localhost:3000');
// var ceres = new Asteroid('breadcrumbs.ninja');

// on start, check if authenticated
chrome.storage.local.get('breadcrumbsID', function(items) {
  if (items.breadcrumbsID && items.breadcrumbsID !== 0) {
    id = items.breadcrumbsID;
    $('#logout').show();
    $('#login').hide();
    $('#error').hide();
  }
  else {
    id = 0;
  }
  console.log(id);
});

function authenticate(event) {
  event.preventDefault();
  var loginRes = ceres.loginWithPassword(event.target.username.value, event.target.password.value);
  loginRes.then(function(uid) {
    id = uid;
    $('#logout').show();
    $('#login').hide();
    $('#error').hide();
    chrome.storage.local.set({breadcrumbsID: uid});
  }).fail(function(err) {
    $('#error').show();
  });
}

window.addEventListener('load', function(evt) {
  document.getElementById('login').addEventListener('submit', authenticate);
});

$('#logout-btn').click(function(evt) {
  ceres.logout();
  $('#logout').hide();
  $('#login').show();
  id = 0;
  chrome.storage.local.set({breadcrumbsID: id});
});