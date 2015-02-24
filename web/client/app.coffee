Meteor.subscribe 'refined_data', {uid: Meteor.userId()}
Meteor.subscribe 'allUserData', {user: Meteor.userId()}