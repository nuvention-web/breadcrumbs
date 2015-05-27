Template.forgotPassword.events 
  'submit #forgotPasswordForm': (e, t) ->
    e.preventDefault()
    forgotPasswordForm = $(e.currentTarget)
    email = trimInput(forgotPasswordForm.find('#forgotPasswordEmail').val().toLowerCase())
    if isNotEmpty(email) and isEmail(email)
      console.log 'clicked1'
      Accounts.forgotPassword { email: email }, (err) ->
        console.log 'clicked'
        if err
          if err.message == 'User not found [403]'
            console.log 'This email does not exist.'
          else
            console.log 'We are sorry but something went wrong.'
        else
          alert 'Email Sent. Check your mailbox.'
    false

if Accounts._resetPasswordToken
  Session.set 'resetPassword', Accounts._resetPasswordToken


Template.resetPassword.helpers
  resetPassword: () ->
    Session.get 'resetPassword'

Template.resetPassword.events 
  'submit #resetPasswordForm': (e, t) ->
    e.preventDefault()
    resetPasswordForm = $(e.currentTarget)
    password = resetPasswordForm.find('#resetPasswordPassword').val()
    passwordConfirm = resetPasswordForm.find('#resetPasswordPasswordConfirm').val()
    if isNotEmpty(password) and areValidPasswords(password, passwordConfirm)
      Accounts.resetPassword Session.get('resetPassword'), password, (err) ->
        if err
          console.log 'We are sorry but something went wrong.'
        else
          console.log 'Your password has been changed. Welcome back!'
          Session.set 'resetPassword', null
    false