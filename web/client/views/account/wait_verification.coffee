Template.waitVerification.events
	'click #send-verification': (e) ->
		# e.preventDefault()
		console.log 'clicked'
		email = Session.get('unverifiedEmail')
		#   	console.log 'email is ' + email
		# user = Meteor.users.findOne({'emails.address': email})
		# console.log user
		# console.log user._id
		# user = Meteor.call('getUserId', email)
		# console.log user
		Meteor.call('sendVerificationEmail', null, email)
		Session.set('currentRegisterEmail', email)
		Router.go '/thankyou'
