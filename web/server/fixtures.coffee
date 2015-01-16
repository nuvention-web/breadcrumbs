if Meteor.users.find().count() is 0
  admin = Assets.getText('admin').split(',')

  Accounts.createUser 
    username: admin[0]
    email: admin[1]
    password: admin[2]
    profile:
      first_name: admin[3]
      last_name: admin[4]