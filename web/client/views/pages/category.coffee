Template.category.helpers
    headline: () ->
        return RefinedData.findOne {category: this.name}, {sort: {score: -1}}

    pages: () ->
        return RefinedData.find {category: this.name}, {sort: {score: -1}, skip: 1, limit: 5}
