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
    # if RefinedData.find({uid: user._id}).count() < PageData.find({uid: user._id}).count()
    #     RefinedData.remove {uid: user._id}
    #     PageData.find({uid: user._id}).forEach (view) ->
    #         exists = RefinedData.findOne {url: view.url}
    #         if exists?
    #             RefinedData.update exists, {$inc: {count: 1}}
    #         else
    #             RefinedData.insert refineView(view)

    # if Categories.find({user: user._id}).count() == 0
    #     defaultCategories = 
    #         [
    #             {
    #                 name: 'Social Media'
    #                 keywords: ['google', 'reddit', 'facebook', 'twitter']
    #                 priority: 1
    #             },
    #             {
    #                 name: 'News'
    #                 keywords: ['journal', 'times', 'today', 'post', 'tribune', 'chronicle', 'news', 'inquirer', 'globe']
    #                 priority: 2,
    #             },
    #             {
    #                 name: 'Uncategorized'
    #                 keywords: ['']
    #                 priority: 3
    #             }
    #         ]

    #     for i in defaultCategories
    #         i.user = user._id
    #         Categories.insert i