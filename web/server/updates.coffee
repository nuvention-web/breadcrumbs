RefinedData.find().forEach (view) ->
    if view.counts?
        view.count = view.counts
        view.counts = null