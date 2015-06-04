Template.thankyou.helpers
	email: () ->
		return Session.get('currentRegisterEmail') 
	contactEmail: () ->
		return Session.get('contactFormEmail')
	fromContact: () ->
		return Session.get('contactFormSubmit')
