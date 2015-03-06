Meteor.methods
    refreshDB: (uid) -> # offload to client?
        console.log 'Refreshing for ' + uid

        RefinedData.remove {uid: uid}
        pages = PageData.find {uid: uid}
        pages.forEach (page) ->

            view = refineView page

            id = RefinedData.findOne {url: view.url}
            if id?
              RefinedData.update id, {$inc: {count: 1, totalTime: view.totalTime}, $push: {visits: view.visits[0]}}
              if id.visits.length > 10
                RefinedData.update id, {$pop: {visits: -1}}
            else
              view.counts = 1
              RefinedData.insert view

    makeUser: (user) ->
        Accounts.createUser user

    pingTest: (data) ->
        console.log '[PING]'
        console.log data
        return '[PONG]'
