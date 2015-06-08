# when a user is created...
Accounts.onCreateUser (options, user) ->
  user.profile = {}
  # we wait for Meteor to create the user before sending an email
  Meteor.call('sendVerificationEmail', user)

# validate login
Accounts.validateLoginAttempt (attempt) ->
  if attempt.user and attempt.user.emails and !attempt.user.emails[0].verified
    # console.log 'email not verified'
    return false
    # the login is aborted
  true
