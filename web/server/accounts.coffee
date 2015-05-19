Accounts.onCreateUser (options, user) ->
  console.log user
  user.profile = {}
  # we wait for Meteor to create the user before sending an email
  Meteor.setTimeout (->
    Accounts.sendVerificationEmail user._id
    return
  ), 2 * 750
  
  user

Accounts.validateLoginAttempt (attempt) ->
  if attempt.user and attempt.user.emails and !attempt.user.emails[0].verified
    console.log 'email not verified'
    return false
    # the login is aborted
  true
