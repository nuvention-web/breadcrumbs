## bind resort and save on exit

Template.categories.helpers
    categories: () ->
        return Categories.find {}, {sort: {priority: 1} }
    sortOptions: () ->
        return {
            sortField: 'priority'
            animation: 500
        }
    isCategory: (name) ->
        return name != 'Uncategorized'

Template.categories.events
    'click .adder-wait': (event) ->
        event.preventDefault()
        event.stopPropagation()
        toggleAdder()
    'click #cancel': (event) ->
        event.preventDefault()
        event.stopPropagation()
        toggleAdder()

    'mouseenter .category': (event) ->
        $(event.currentTarget.children[1]).slideToggle()

    'mouseleave .category': (event) ->
        $(event.currentTarget.children[1]).slideToggle()

    'click .delete': (event) ->
        Categories.remove this._id

    'submit form': (event) ->
        event.preventDefault()
        event.stopPropagation()
        name = event.target.category.value
        tags = event.target.tags.value.split ' '

        event.target.category.value = ''
        event.target.tags.value = ''

        while (tags.indexOf("") is not -1)
            tags.splice tags.indexOf(""), 1

        category =
            name: name
            keywords: tags
            priority: Categories.find().count() + 1
            user: Meteor.userId()

        Categories.insert category
        Meteor.call 'refreshDB', Meteor.userId()
        toggleAdder()

toggleAdder = ()->
    $('.adder-wait').slideToggle()
    $('.adder-add').slideToggle()