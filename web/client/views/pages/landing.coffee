Session.setDefault("loginClicked", true)


Template.landing.helpers
  loginClicked: () ->
    return Session.get("loginClicked")
  loggedIn: () ->
    user = Meteor.users.findOne(this.userId)
    console.log Meteor.userId
    console.log Meteor.user() != undefined
    return Meteor.user() != undefined





Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });
