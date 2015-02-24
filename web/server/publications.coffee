Meteor.publish 'refined_data', () ->
    return RefinedData.find {uid: this.userId}

Meteor.publish 'allUserData', () ->
    return Meteor.users.find {}, {fields: {'categories': 1, 'name': 1, 'email': 1}}