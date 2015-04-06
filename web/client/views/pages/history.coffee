Template.history.helpers
	items: () ->
		return Categories.findOne({_id: this.category}).items
		