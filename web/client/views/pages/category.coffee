Template.category.helpers
    image: (items) ->
        for item in items
            if Items.findOne({_id: item}).image?
                return Items.findOne({_id: item}).image
    url: (items) ->
        return Items.findOne({_id: item}).url
        # for item in items
        #     if Items.findOne({_id: item}).url?
        #         return Items.findOne({_id: item}).url


