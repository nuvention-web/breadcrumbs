@crumble = new ReactiveVar ''
@filter = new ReactiveVar ''

Template.nav.helpers
  category: () ->
    return crumble.get()

Template.nav.events
  'keyup .form-control': (event) ->
    filter.set event.target.value
  'click #logout': (e, t) ->
    e.preventDefault()
    e.stopPropagation()
	  Meteor.logout ->
	    console.log 'Bye Meteorite! Come back whenever you want!'
	    return
	  false