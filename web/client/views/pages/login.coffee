

Template.login.events 'submit #loginForm': (e, t) ->
  e.preventDefault()
  signInForm = $(e.currentTarget)
  email = trimInput(signInForm.find('#email').val().toLowerCase())
  password = signInForm.find('#password').val()
  if isNotEmpty(email) and isEmail(email) and isNotEmpty(password) and isValidPassword(password)
    Meteor.loginWithPassword email, password, (err) ->
      if err
        console.log 'These credentials are not valid.'
      else
        console.log 'Welcome back Meteorite!'
        Router.go '/dashboard'
      return
  false

