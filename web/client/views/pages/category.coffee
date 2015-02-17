Template.category.helpers
    headline: () ->
        return (RefinedData.findOne {category: this.category}, {sort: {count: -1}}).pages[0]

    pages: () ->
        return RefinedData.find {category: this.category}, {sort: {count: -1}, skip: 1, limit: 5}
