@Items = new Mongo.Collection 'items'

Items.allow
    update: (userId, doc, fields, modifier) ->
        if doc.uid is userId
            return true
        else
            return false
    remove: (userId, doc) ->
        if doc.uid is userId
            return true
        else
            return false