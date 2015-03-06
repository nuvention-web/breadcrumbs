Template.dashboard.helpers
    categories: () ->
        return Categories.find()

Template.dashboard.rendered = () ->
    # if not Meteor.user()
    #     Router.go '/login'