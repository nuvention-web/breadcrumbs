@crumble = new ReactiveVar ''
@filter = new ReactiveVar ''

Template.nav.helpers
  category: () ->
    return crumble.get()

Template.nav.events
  'click #logout': (event) ->
    event.preventDefault()
    event.stopPropagation()
    Meteor.logout()
  'keyup .form-control': (event) ->
    filter.set event.target.value
