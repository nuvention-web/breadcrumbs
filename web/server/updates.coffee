
# 4/10/2015 Comment this all out after you've restarted the server once!

Items.find().forEach (item) ->
    if not Sites.findOne {name: item.site}
      Sites.insert({name: item.site, uid: item.uid})


# # 4/2/2015
# Items.find().forEach (item) ->
#   if item.web_taxonomy?
#     done = false
#     Categories.find({uid: item.uid}).forEach (category) ->
#       [sufficient, not_matched] = matchKeywords(item.web_taxonomy, category.keywords)
#       if sufficient and not done
#         console.log('Matched to category ' + category.name + '.')
#         console.log(category.keywords)
#         console.log(item.web_taxonomy)
#         Items.update item, {$set: {category: category.name, filter_name: classify(category.name)}}
#         # Categories.update category, {$push: {
#         #                                     keywords: {$each: not_matched},
#         #                                     items: item._id}}
#         done = true
#     if not done
#       new_category =
#         name: item.web_taxonomy[item.web_taxonomy.length - 1]
#         keywords: item.web_taxonomy
#         uid: item.uid
#         items: [item._id]
#       console.log('Creating new category: ' + new_category.name)
#       Items.update item, {$set: {category: new_category.name, filter_name: classify(new_category.name)}}
#       Categories.insert new_category
#   else
#     # no keywords
#     done = false
#     Categories.find({uid: item.uid}).forEach (category) ->
#       matched = matchSingleName(item.name, category.keywords)
#       if matched and not done
#         console.log('Matched to category ' + category.name + '.')
#         console.log(category.keywords)
#         console.log(item.name)
#         Items.update item, {$set: {category: category.name, filter_name: classify(category.name)}}
#         # Categories.update category, {$push: {items: item._id}}
#         done = true
#     if not done
#       # this'll be complex...
#       new_category =
#         name: item.name
#         keywords: []
#         uid: item.uid
#         items: [item._id]
#       console.log('Creating new category: ' + new_category.name)
#       Items.update item, {$set: {category: new_category.name, filter_name: classify(new_category.name)}}
#       Categories.insert new_category

# Categories.find().forEach (category) ->
#   Categories.update category, {$set: {filter_name: classify(category.name)}}
