@crumble = new ReactiveVar ''
@filter = new ReactiveVar ''

Template.navbar.helpers
  category: () ->
    return crumble.get()
  name: () ->
    return Meteor.user().username

Template.navbar.events
  'click #logout': (event) ->
    event.preventDefault()
    event.stopPropagation()

    Meteor.logout()
  'keyup .form-control': (event) ->
    filter.set event.target.value