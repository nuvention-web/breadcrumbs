Template.login.created = () ->
  # if Meteor.user() is 'admin'
  #   Router.go('/admin')

Template.login.events
  'submit form': (event) ->
    event.preventDefault()
    event.stopPropagation()
    console.log Meteor.user()

    Meteor.loginWithPassword(event.target.username.value, event.target.password.value, (err) ->
      if (err)
        alert err
      else
        Router.go('/dashboard'))
    