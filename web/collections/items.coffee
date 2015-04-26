@Items = new Mongo.Collection 'items'

Items.allow
    remove: (userId, doc) ->
        if doc.uid is userId
            return true
        else
            return false