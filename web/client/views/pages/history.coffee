Template.history.helpers
  sites: () ->
    return RefinedData.find {category: this.category}, {sort: {score: -1}}
