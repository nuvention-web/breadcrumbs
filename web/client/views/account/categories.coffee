## bind resort and save on exit

Template.categories.helpers
    categories: () ->
        return Meteor.users.findOne(Meteor.userId()).categories
    lowestPriority: () ->
        return Meteor.user().categories.length

Template.categories.events
    'click .adder-wait': (event) ->
        event.preventDefault()
        event.stopPropagation()
        toggleAdder()
    'click #cancel': (event) ->
        toggleAdder()
    'click #save': (event) ->
        $('#save').attr('disabled','disabled');

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
            priority: Meteor.user().categories.length

        Meteor.users.update Meteor.userId(), {$push: {categories: category}}
        updateCategories()
        Meteor.call 'refreshDB', Meteor.userId()
        toggleAdder()

Template.categories.rendered = () ->
    updateCategories()

    options =
        animation: 200
        onEnd: (event) ->
            $('#save').removeAttr('disabled')
            prev = event.oldIndex
            curr = event.newIndex
            categories = Meteor.user().categories
            if curr < prev
                for i in [curr..prev]
                    categories[i].priority += 1
                categories[prev].priority = curr
            else if curr > prev
                for i in [prev+1..curr+1]
                    categories[i].priority -= 1
                categories[prev].priority = curr

            updateCategories(categories)
                
    sortable = Sortable.create $('.list')[0], options

toggleAdder = ()->
    $('.adder-wait').toggle()
    $('.adder-add').toggle()

updateCategories = (newCategories) ->
    console.log Meteor.user()?.categories
    if not newCategories?
        newCategories = Meteor.user()?.categories
    console.log newCategories
    newCategories?.sort (x, y) -> return x.priority - y.priority # move this else where
    Meteor.users.update Meteor.userId(), {$set: {categories: newCategories}}