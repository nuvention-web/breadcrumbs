# ['Telehealth', 'Healthcare', 'Business', 'News', 'Companies', 'Other']

@chooseCategory = (entry) ->
    telehealth = ['health', 'hospital', 'medicine']
    # healthcare = ['healthcare', 'health', 'hospital', 'medicine']
    business = ['economy', 'stocks', 'business', 'bank', 'money']
    news = ['journal', 'times', 'today', 'post', 'tribune', 'chronicle', 'news', 'inquirer', 'globe']
    general = ['google', 'reddit', 'facebook', 'evernote', 'yahoo', 'github']
    companies = ['career']

    if checkFor entry, telehealth
        return 'Telehealth'
    # else if checkFor entry, healthcare
    #     return 'Healthcare'
    else if checkFor entry, business
        return 'Business'
    else if checkFor entry, news
        return 'News'
    else if checkFor entry, general
        return 'General'
    else if checkFor entry, companies
        return 'Companies'
    else
        return 'Unclassified'

@checkFor = (entry, keywords) ->
    for key in keywords
        if entry.domain.toLowerCase().indexOf key > -1
            console.log key
            return true
        else
            for page in entry.pages
                if page.url.toLowerCase().indexOf key > -1 or page.title.toLowerCase().indexOf key > -1
                    return true
    return false

@score = (entry) ->
    maxTime = 0
    for page in entry.pages
        if page.end > maxTime
            maxTime = page.end
    return (maxTime / 8000000) + entry.count

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
