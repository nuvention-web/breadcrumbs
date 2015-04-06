Template.history.helpers
    items: () ->
        return Categories.findOne({_id: Router.current().params.id}).items