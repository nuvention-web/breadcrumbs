Session.setDefault("loginClicked", true)

$ ->
  
  $('#about-us').bind 'click', (event) ->
    console.log 'this'
    $anchor = $(this)
    $('html, body').stop().animate { scrollTop: $($anchor.attr('href')).offset().top }, 1000

    ###
    if you don't want to use the easing effects:
    $('html, body').stop().animate({
        scrollTop: $($anchor.attr('href')).offset().top
                                    }, 1000);
    ###

    event.preventDefault()
    return

    # $('#about-us').click ->
    #   console.log 'click'
    #   $('html,body').animate { scrollTop: $('#about-us').offset().top }, 'slow'
    # return
    # console.log 'documentreached'

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
