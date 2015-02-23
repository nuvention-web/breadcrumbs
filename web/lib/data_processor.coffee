@refineView = (view) ->
	view.title = view.title || view.url
	view.favIcon = view.favIcon || 'http://www.acsu.buffalo.edu/~rslaine/imageNotFound.jpg'
	view.category = chooseCategory view, view.uid
	view.score = score view

	return view

@chooseCategory = (entry, uid) ->
    user = Meteor.users.findOne(uid, {reactive: false})
    user.categories.sort (x, y) -> return x.priority - y.priority
    for category in user.categories
        if checkFor entry, category.keywords
            return category.name
    return 'Uncategorized'

@checkFor = (entry, keywords) ->
    for key in keywords
        if (entry.domain.toLowerCase().indexOf(key) > -1) or 
        	(entry.url.toLowerCase().indexOf(key) > -1) or
        	(entry.title.toLowerCase().indexOf(key) > -1)
            return true
    return false

@score = (entry) ->
    return (entry.end / 8000000) + entry.count