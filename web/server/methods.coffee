Meteor.methods
    refreshDB: (uid) -> # offload to client?
        console.log 'Refreshing for ' + uid

        RefinedData.remove {uid: uid}
        Domains.remove {uid: uid}
        PageData.find({uid: uid}).forEach (page) ->
            view = refineView page

            console.log view
            
            id = RefinedData.findOne {uid: uid, url: view.url}
            if id?
                RefinedData.update id, {$inc: {count: 1, totalTime: view.totalTime}, $push: {visits: view.visits[0]}, $set: {end: view.end, start: view.start}}
                if id.visits.length > 10
                    RefinedData.update id, {$pop: {visits: -1}}
            else
                view.counts = 1
                RefinedData.insert view
        RefinedData.find({uid: uid}).forEach (page) ->
            dom = Domains.findOne {uid: uid, domain: page.domain, category: page.category}
            if dom?
                Domains.update dom, {
                    $push: {pages: page._id}, 
                    $inc: {count: page.count, totalTime: page.totalTime}, 
                    $set: {favIcon: dom.favIcon || page.favIcon}}
            else
                domain = {
                    pages: [page._id]
                    count: page.count
                    totalTime: page.totalTime
                    domain: page.domain
                    favIcon: page.favIcon
                    category: page.category
                    uid: uid
                }
                Domains.insert domain

    makeUser: (user) ->
        Accounts.createUser user

    pingTest: (data) ->
        console.log '[PING]'
        console.log data
        return '[PONG]'
