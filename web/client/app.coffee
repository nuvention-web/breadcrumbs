Meteor.subscribe 'refined_data', {uid: Meteor.userId()} ## why does this not fucking work
Meteor.subscribe 'allUserData', {user: Meteor.userId()}
Meteor.subscribe 'categories'