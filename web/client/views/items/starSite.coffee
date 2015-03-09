Template.starSite.helpers
    favIconOr: () ->
        return this.favIcon || 'http://www.yustrans.ro/favicon.ico'

Template.starSite.rendered = () ->
    console.log this