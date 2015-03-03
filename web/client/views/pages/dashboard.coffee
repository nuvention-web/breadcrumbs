Template.dashboard.helpers
    categories: () ->
        return Meteor.user().categories

Template.dashboard.rendered = () ->
    # if not Meteor.user()
    #     Router.go '/login'