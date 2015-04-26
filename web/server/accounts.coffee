Accounts.onCreateUser (options, user) ->
  user.profile = {}
  # we wait for Meteor to create the user before sending an email
  Meteor.setTimeout (->
    Accounts.sendVerificationEmail user._id
    return
  ), 2 * 1000
  user