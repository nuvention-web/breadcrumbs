Meteor.methods
    # refreshDB: () ->
    #     RefinedData.remove {}
    #     pages = PageData.find()
    #     pages.forEach (page) ->
    #         if RefinedData.find(domain: page.domain).count() is 0
    #             page.title = page.title || '[Title not found]'
    #             page.favIcon = page.favIcon || 'http://www.acsu.buffalo.edu/~rslaine/imageNotFound.jpg'

    #             entry = {}
    #             entry.domain = page.domain
    #             entry.count = 1
    #             entry.pages = [page]
    #             entry.category = chooseCategory entry
    #             entry.importance = score entry

    #             RefinedData.insert(entry)
    #         else
    #             RefinedData.update domain: page.domain, 
    #                 $inc: 
    #                     count: page.counts
    #                 $push:
    #                     pages: page

    makeUser: (user) ->
        Accounts.createUser user

    pingTest: (data) ->
        console.log '[PING]'
        console.log data
        return '[PONG]'
