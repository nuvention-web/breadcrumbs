Accounts.onCreateUser (options, user)->
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
                priority: 0,
            },
            {
                name: 'Uncategorized'
                keywords: ['']
                priority: Number.POSITIVE_INFINITY
            }
        ]

    for i in defaultCategories
        Categories.insert {user: user._id, category: i}


    return user