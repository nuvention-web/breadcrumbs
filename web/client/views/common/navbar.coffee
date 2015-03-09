Template.navbar.helpers
    name: () ->
        return Meteor.user().username

Template.navbar.events
    'click #logout': (event) ->
        event.preventDefault()
        event.stopPropagation()

        Meteor.logout()