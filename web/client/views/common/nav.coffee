Template.nav.events
    'click #logout': (e) ->
        e.preventDefault()
        e.stopPropagation()
        Meteor.logout ->
        	Router.go '/landing'
        console.log 'Bye Meteorite! Come back whenever you want!'
        
$(document).ready ->
  $('.navbar-right .bc-button').hover ->
    console.log 'HOVERED'
    return
  return