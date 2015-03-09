@refineView = (view) ->
    view.title = view.title || view.url
    view.favIcon = view.favIcon
    view.category = chooseCategory view, view.uid
    view.score = score view
    view.totalTime = view.end - view.start
    view.count = 1
    view.visits = [[view.start, view.end]]

    return view

@chooseCategory = (entry, uid) ->
    returnCategory = 'Uncategorized'
    Categories.find({user: uid}, {sort: {priority: -1}}).forEach (category) ->
        if checkFor entry, category.keywords
            returnCategory = category.name
    return  returnCategory

@checkFor = (entry, keywords) ->
    for key in keywords
        if entry.domain.toLowerCase().indexOf(key.toLowerCase()) != -1 or 
        entry.url.toLowerCase().indexOf(key.toLowerCase()) != -1 or 
        entry.title.toLowerCase().indexOf(key.toLowerCase()) != -1
            return true
    return false

@score = (entry) ->
    return entry.end

invalidPatterns = [
    "ftp://",
    "file://",
    "localhost:",
]

@invalidURL = (url) ->
    return not _.every(invalidPatterns, (pattern) -> url.indexOf(pattern) == -1)