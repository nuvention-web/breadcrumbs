Template.category.helpers
    headline: () ->
        return RefinedData.findOne {category: this.name, uid: Meteor.userId()}, {sort: {score: -1}}

    pages: () ->
        return RefinedData.find {category: this.name, uid: Meteor.userId()}, {sort: {score: -1}, skip: 1, limit: 5}
