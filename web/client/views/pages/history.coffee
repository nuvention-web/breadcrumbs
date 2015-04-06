Template.history.helpers
    items: () ->
        item_list = Categories.findOne({_id: Router.current().params.id})?.items
        item_obj_list = []
        for item in item_list
            item_obj_list.push(Items.findOne({_id: item}))
        return item_obj_list