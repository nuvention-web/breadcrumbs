Template.categories.rendered = () ->
    crumble.set '/categories'


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
        $(event.currentTarget.children[1]).show()

    'mouseleave .category': (event) ->
        $(event.currentTarget.children[1]).hide()

    'click .delete': (event) ->
        priority = this.priority

        Categories.remove this._id
        Categories.find({ priority: {$gt: priority} }).forEach (category) ->
            Categories.update {_id: category._id}, {$inc: {priority: -1}}

    'submit form': (event) ->
        event.preventDefault()
        event.stopPropagation()
        name = event.target.category.value
        tags = event.target.tags.value.split ' '

        event.target.category.value = ''
        event.target.tags.value = ''

        while (tags.indexOf("") is not -1)
            tags.splice tags.indexOf(""), 1

        next_priority = (Categories.findOne {}, {sort: {priority: -1}}).priority + 1

        category =
            name: name
            keywords: tags
            priority: next_priority
            user: Meteor.userId()

        Categories.insert category
        # Meteor.call 'refreshDB', Meteor.userId()
        toggleAdder()

toggleAdder = ()->
    $('.adder-wait').slideToggle()
    $('.adder-add').slideToggle()