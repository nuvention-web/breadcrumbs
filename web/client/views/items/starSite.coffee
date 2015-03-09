Template.starSite.helpers
    favIconOr: () ->
        return this.favIcon || 'http://www.yustrans.ro/favicon.ico'

    getPages: () ->
        return RefinedData.find {_id: {$in: this.pages}}, {sort: {totalTime: -1}}

Template.starSite.rendered = () ->
    # console.log this

Template.starSite.events
    'click .main': (event) ->
        $(event.currentTarget).next().slideToggle();