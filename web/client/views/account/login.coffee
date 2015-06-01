Template.login.created = ->
  if Accounts._verifyEmailToken
    Accounts.verifyEmail Accounts._verifyEmailToken, (err) ->
      if err != null
        if err.message = 'Verify email link expired [403]'
          console.log 'Sorry this verification link has expired.'
      else
        console.log 'Thank you! Your email address has been confirmed.'
      return
  return

Template.login.events 'submit #loginForm': (e, t) ->
  e.preventDefault()
  signInForm = $(e.currentTarget)
  email = trimInput(signInForm.find('#email').val().toLowerCase())
  password = signInForm.find('#password').val()
  if isNotEmpty(email) and isEmail(email) and isNotEmpty(password) and isValidPassword(password)
    Meteor.loginWithPassword email, password, (err) ->
      if err.reason is "Login forbidden"
        Router.go '/verify'
      else if err
        console.log err
        console.log 'These credentials are not valid.'
        alert 'These credentials are not valid.'
      else
        Router.go '/dashboard'
      return
  false

