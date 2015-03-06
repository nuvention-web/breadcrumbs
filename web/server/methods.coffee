Meteor.methods
    refreshDB: (uid) -> # offload to client?
        console.log 'Refreshing for ' + uid
        user = Meteor.users.findOne uid, {reactive: false}
        user.categories.sort (x, y) -> return x.priority - y.priority # move this else where
        Meteor.users.update uid, {$set: {categories: user.categories}}

        RefinedData.remove {uid: uid}
        pages = PageData.find {uid: uid}
        pages.forEach (page) ->

            view = refineView page

            id = RefinedData.findOne {url: view.url}
            if id?
              RefinedData.update id, {$inc: {counts: 1}}
            else
              view.counts = 1
              RefinedData.insert view

    makeUser: (user) ->
        Accounts.createUser user

    pingTest: (data) ->
        console.log '[PING]'
        console.log data
        return '[PONG]'
