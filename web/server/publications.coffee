Meteor.publish 'refined_data', () ->
    return RefinedData.find {}

Meteor.publish 'allUserData', () ->
    return Meteor.users.find {}, {fields: {'categories': 1, 'name': 1, 'email': 1}}