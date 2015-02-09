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