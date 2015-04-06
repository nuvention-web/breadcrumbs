Template.category_history.helpers
    image: () ->
        console.log(Items.findOne({_id: this}))
    #     if Items.findOne({_id: this})?.image?
    #         return Items.findOne({_id: this}).image
    # url: () ->
    #     if Items.findOne({_id: this})?.url?
    #         return Items.findOne({_id: this}).url
    # name: () ->
    #     if Items.findOne({_id: this})?.name?
    #         return Items.findOne({_id: this}).name




