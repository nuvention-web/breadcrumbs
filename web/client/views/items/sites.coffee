Template.site.helpers
    pages: () ->
        return this.pages

Template.site.events
    'click .item': (e) ->
        e.preventDefault()
        $(e.target.children[2]).toggle 200
