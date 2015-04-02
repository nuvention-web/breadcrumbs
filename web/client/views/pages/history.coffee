Template.history.helpers
  sites: () ->
    return RefinedData.find {category: this.category, $where: filterSites}, {sort: {end: -1}}
  starSites: () ->
    return Domains.find {category: this.category, $where: filterStarSites}, {sort: {totalTime: -1}}

Template.history.rendered = () ->
    crumble.set('/' + this.data.category)

# inside = (bigString, smallString) ->
#     return bigString.indexOf(smallString) != -1

# filterSites = () ->
#     return (inside(this.url, filter.get()) or inside(this.title, filter.get()))

# filterStarSites = () ->
#     if inside(this.domain, filter.get())
#         return true

#     for page in this.pages
#         rPage = RefinedData.findOne({_id: page})
#         if inside(rPage.url, filter.get()) or inside(rPage.title, filter.get())
#             return true
#     return false
#     