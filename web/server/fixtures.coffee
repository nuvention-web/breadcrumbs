# ['Telehealth', 'Healthcare', 'Business', 'News', 'Companies', 'Other']

chooseCategory = (entry) ->
    keywords = ['Telehealth', 'Healthcare', 'Business']
    for category in keywords
        if entry.domain.indexOf(category) > -1
            console.log category
            return category
        else
            for page in entry.pages
                if page.url.indexOf(category) > -1 or page.title.indexOf(category) > -1
                    return category

    news = ['journal', 'times', 'today', 'post', 'tribune', 'chronicle', 'news', 'inquirer', 'globe']
    for key in news
        if entry.domain.indexOf(key) > -1
            return 'News'

    general = ['google', 'reddit', 'facebook', 'evernote', 'yahoo', 'github']
    for key in general
        if entry.domain.indexOf(key) > -1
            return 'General'

    for page in entry.pages
        if page.url.indexOf('career') > -1 or page.title.indexOf('career') > -1
            return 'Companies'

    return 'Unclassified'

score = (entry) ->
    return entry.end

if Meteor.users.find().count() is 0
  admin = Assets.getText('admin').split(',')

  Accounts.createUser 
    username: admin[0]
    email: admin[1]
    password: admin[2]
    profile:
      first_name: admin[3]
      last_name: admin[4]

if RefinedData.find().count() is 0
    pages = PageData.find()
    pages.forEach (page) ->
        if RefinedData.find(domain: page.domain).count() is 0
            page.title = page.title || '[Title not found]'
            page.favIcon = page.favIcon || 'http://www.acsu.buffalo.edu/~rslaine/imageNotFound.jpg'

            entry = {}
            entry.domain = page.domain
            entry.count = 1
            entry.pages = [page]
            entry.category = chooseCategory entry
            entry.importance = score entry

            RefinedData.insert(entry)
        else
            RefinedData.update domain: page.domain, 
                $inc: 
                    count: page.counts
                $push:
                    pages: page
