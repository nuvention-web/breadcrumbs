Session.setDefault("loginClicked", true)


Template.landing.helpers
  loginClicked: () ->
    return Session.get("loginClicked")
  loggedIn: () ->
    user = Meteor.users.findOne(this.userId)
    console.log Meteor.userId
    console.log Meteor.user() != undefined
    return Meteor.user() != undefined

Template.landing.events
  'submit form': (event) ->
    event.preventDefault()
    event.stopPropagation()
    $('#messages').hide()

    name = event.target.fullname.value
    email = event.target.email.value

    if Interest.findOne {email: email}
      $('#messages').show()
    else
      Interest.insert {name: name, email: email}
      Router.go '/thanks'


Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });
