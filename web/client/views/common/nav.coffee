Template.nav.events
    'click #logout': (e) ->
        e.preventDefault()
        e.stopPropagation()
        Meteor.logout ->
        	Router.go '/'
        # console.log 'Bye Meteorite! Come back whenever you want!'