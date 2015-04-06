Template.dashboard.helpers
    categories: () ->
        return Categories.find()
    length: (items) ->
        return items.length



# Template.dashboard.rendered = () ->
#     crumble.set '/dashboard'
#     # if not Meteor.user()
#     #     Router.go '/login'

# Template.dashboard.events
#     'click .glyphicon-refresh': (event) ->
#         event.preventDefault()
#         event.stopPropagation()

#         Meteor.call('refreshDB', Meteor.userId())