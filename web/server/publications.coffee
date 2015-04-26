Meteor.publish 'items', () ->
    if this.userId
        return Items.find {uid: this.userId}
    else
        this.ready()

Meteor.publish 'categories', () ->
    if this.userId
        return Categories.find {uid: this.userId}
    else
        this.ready()

Meteor.publish 'allUserData', () ->
    if this.userId
        return Meteor.users.find {}, {fields: {'categories': 1, 'name': 1, 'email': 1}}
    else
        this.ready()

Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        return true
    