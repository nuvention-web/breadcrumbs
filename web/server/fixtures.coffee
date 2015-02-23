if Meteor.users.find().count() is 0
    admin = Assets.getText('admin').split(',')

    Accounts.createUser 
        username: admin[0]
        email: admin[1]
        password: admin[2]
        profile:
          first_name: admin[3]
          last_name: admin[4]

Meteor.users.find().forEach (user) ->
    if RefinedData.find({uid: user._id}).count() < PageData.find({uid: user._id})
        RefinedData.remove {uid: user._id}
        PageData.find({uid: user._id}).forEach (view) ->
            exists = RefinedData.findOne {url: view.url}
            if exists?
                RefinedData.update exists, {$inc: {count: 1}}
            else
                RefinedData.insert refineView(view)
