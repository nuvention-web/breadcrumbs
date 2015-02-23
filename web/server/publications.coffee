Meteor.publish 'refined_data', () ->
    return RefinedData.find {}