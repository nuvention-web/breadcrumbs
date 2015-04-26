Template.nav.events
  'click #logout': (event) ->
    event.preventDefault()
    event.stopPropagation()
    Meteor.logout()
  'keyup .form-control': (event) ->
    filter.set event.target.value
