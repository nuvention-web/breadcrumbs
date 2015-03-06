Meteor.users.find().forEach (user) ->
    if Categories.find({user: user._id}).count() == 0
        defaultCategories = 
            [
                {
                    name: 'Social Media'
                    keywords: ['google', 'reddit', 'facebook', 'twitter']
                    priority: 1
                },
                {
                    name: 'News'
                    keywords: ['journal', 'times', 'today', 'post', 'tribune', 'chronicle', 'news', 'inquirer', 'globe']
                    priority: 2,
                },
                {
                    name: 'Uncategorized'
                    keywords: ['']
                    priority: 3
                }
            ]

        for i in defaultCategories
            i.user = user._id
            Categories.insert i