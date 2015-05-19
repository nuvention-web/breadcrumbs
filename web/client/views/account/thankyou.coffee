Template.thankyou.helpers
	email: () ->
		return Session.get('currentRegisterEmail') 