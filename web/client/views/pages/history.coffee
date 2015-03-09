Template.history.helpers
  sites: () ->
    return RefinedData.find {category: this.category}, {sort: {end: -1}}
  starSites: () ->
    return Domains.find {category: this.category}, {sort: {totalTime: -1}}
