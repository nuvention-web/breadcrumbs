Session.setDefault("loginClicked", true)

$ ->
 
  $('a[href^="#"]').on 'click.smoothscroll', (e) ->
    console.log 'clicked'
    e.preventDefault()
 
    target = @hash
    $target = $(target)
 
    $('html, body').stop().animate {
      'scrollTop': $target.offset().top
    }, 500, 'swing', ->
      window.location.hash = target
  console.log 'documentreached'

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

  'click #login' : (e) ->
    e.preventDefault();
    console.log Session.get('loginClicked')
    if Session.get("loginClicked")
      Session.set("loginClicked", false)
    else 
      Session.set("loginClicked", true)

Accounts.ui.config({
    passwordSignupFields: "USERNAME_ONLY"
  });
