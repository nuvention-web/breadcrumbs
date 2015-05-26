
# Subcategories.find().forEach (category) ->
#     if category.super_category.name?
#         Subcategories.update category, {$set: { super_category: category.super_category.name }}

Subcategories.remove({})
Brands.remove({})
Items.find().forEach (item) ->
    if item.web_taxonomy
        subcategories = [classify(subcat) for subcat in item.web_taxonomy[1..]][0]
        Items.update item, {$set: {subcategories: subcategories, filter_brand: classify(item.brand)}}
        main_subcategory = item.web_taxonomy[1]
        if not Subcategories.findOne { super_category: item.category, name: main_subcategory, uid: item.uid }
            Subcategories.insert { super_category: item.category, uid: item.uid, name: main_subcategory, filter_name: classify(main_subcategory)}                
                
    if item.brand and not Brands.findOne { brand: item.brand, super_category: item.category, uid: item.uid, filter_brand: classify(item.brand) }
        Brands.insert { brand: item.brand, super_category: item.category, uid: item.uid, filter_brand: classify(item.brand) }

reClassify = () ->
    Items.find().forEach (item) ->
        # item.filter_name = classify item.category
        if item.subcategories
            # for index in [0...item.subcategories.length]
                # item.subcategories[index] = classify(item.subcategories[index])
            item.subcategories = item.subcategories
        Items.update item._id, item

    Categories.find().forEach (category) ->
        Categories.update category, {$set: { filter_name: classify(category.filter_name) }}

    Subcategories.find().forEach (category) ->
        Subcategories.update category, {$set: { filter_name: classify(category.filter_name) }}

# reClassify()

# 4/10/2015 Comment this all out after you've restarted the server once!

# Categories.remove({})

# Items.find().forEach (item) ->
#     web_taxonomy = item.web_taxonomy[1..] if item.web_taxonomy
#     if web_taxonomy
#         for subcat in web_taxonomy
#             if not Subcategories.findOne { super_category: item.category, name: subcat, uid: item.uid }
#                 Subcategories.insert { super_category: item.category, uid: item.uid, name: subcat, filter_name: classify(subcat) }

#         subcategories = [classify(subcat) for subcat in item.web_taxonomy[1..]]

#         category = item.web_taxonomy[0]
#         filter_name = classify item.category
#         Items.update item, {$set: {subcategories: subcategories, category: category, filter_name: filter_name}}

#         category = Categories.findOne {uid: item.uid, name: item.category}
#         if category
#             Categories.update category, {$push: { items: item._id }}
#         else
#             new_category = 
#                 name: item.category
#                 uid: item.uid
#                 items: [item._id]
#                 filter_name: item.filter_name
#             Categories.insert new_category

    # if not Sites.findOne {name: item.site, uid: item.uid}
    #     Sites.insert({name: item.site, uid: item.uid})


# Items.find().forEach (item) ->
#
#
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
#
# Categories.find().forEach (category) ->
#   Categories.update category, {$set: {filter_name: classify(category.name)}}