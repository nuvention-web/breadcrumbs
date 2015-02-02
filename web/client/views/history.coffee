Template.history.helpers
  pages: () ->
    return PageData.find {}, {sort: {counts: -1}}