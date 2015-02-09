Template.history.helpers
  sites: () ->
    return RefinedData.find {category: this.category}, {sort: {end: -1}}
