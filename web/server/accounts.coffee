Accounts.onCreateUser (options, user)->
    user.categories = 
        [
            {
                name: 'Social Media'
                keywords: ['google', 'reddit', 'facebook', 'twitter']
                priority: '1'
            },
            {
                name: 'News'
                keywords: ['journal', 'times', 'today', 'post', 'tribune', 'chronicle', 'news', 'inquirer', 'globe']
                priority: '0',
            },
            {
                name: 'Uncategorized'
                keywords: ['']
                priority: '2'
            }
        ]

    return user