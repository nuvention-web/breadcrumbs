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

    name = event.target.name.value
    email = event.target.email.value
    message = event.target.message.value

# to, from, subject, msg
    Meteor.call('sendEmail',
            email,
            'hi@breadcrumbs.ninja',
            'Hello from Meteor!',
            'Thank you ' + name + " " + email + ' for your feedback! We will be in touch shortly :) \n' + 'Your message: ' + message)
    Meteor.call('sendEmail',
            'hi@breadcrumbs.ninja',
            email,
            'Feedback Receieved. Please Read. From:' +  email,
            message)





Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });
