Template.dashboard.helpers
    categories: () ->
        return Categories.find({}, {sort: {priority: 1}})

Template.dashboard.rendered = () ->
    # if not Meteor.user()
    #     Router.go '/login'

Template.dashboard.events
    'click .glyphicon-refresh': (event) ->
        event.preventDefault()
        event.stopPropagation()

        Meteor.call('refreshDB', Meteor.userId())