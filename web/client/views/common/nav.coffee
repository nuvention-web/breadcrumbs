Template.nav.events
    'click #logout': (e) ->
        e.preventDefault()
        e.stopPropagation()
        Meteor.logout ->
        console.log 'Bye Meteorite! Come back whenever you want!'