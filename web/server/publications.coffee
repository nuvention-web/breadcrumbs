Meteor.publish 'brands', () ->
    if this.userId
        return Brands.find {uid: this.userId}
    else
        this.ready()

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

Meteor.publish 'sites', () ->
    if this.userId
        return Sites.find {uid: this.userId}
    else
        this.ready()

Meteor.publish 'subcategories', () ->
    if this.userId
        return Subcategories.find {uid: this.userId}
    else
        this.ready()

# what does this do??? comment below pls
Meteor.publish 'allUserData', () ->
    if this.userId
        return Meteor.users.find {}, {fields: {'categories': 1, 'name': 1, 'email': 1}}
    else
        this.ready()

Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        return true
    