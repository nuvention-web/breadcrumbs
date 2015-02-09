chooseCategory = (entry) ->
    categories = ['General', 'Telehealth', 'Healthcare', 'Business', 'News', 'Companies']
    return categories[Math.floor(Math.random() * 6)]

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

            RefinedData.insert(entry)
        else
            RefinedData.update domain: page.domain, 
                $inc: 
                    count: page.counts
                $push:
                    pages: page
