Meteor.publish 'items', () ->
    # if this.userId
    #     return Items.find {user: this.userId}
    # else
    #     this.ready()
    return Items.find()

Meteor.publish 'categories', () ->
    # if this.userId
    #     return Categories.find {user: this.userId}
    # else
    #     this.ready()
    return Categories.find()

Meteor.publish 'allUserData', () ->
    if this.userId
        return Meteor.users.find {}, {fields: {'categories': 1, 'name': 1, 'email': 1}}
    else
        this.ready()




Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        return true
    