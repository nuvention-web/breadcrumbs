Session.setDefault("loginClicked", true)


Template.landing.helpers
  loginClicked: () ->
    return Session.get("loginClicked")

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
