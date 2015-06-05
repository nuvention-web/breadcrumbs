Template.waitVerification.events
	'click #send-verification': (e) ->
		# e.preventDefault()
		email = Session.get('unverifiedEmail')
		Meteor.call('sendVerificationEmail', null, email)
		Session.set('currentRegisterEmail', email)
		Router.go '/thankyou'
