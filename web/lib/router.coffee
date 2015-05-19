requireLogin = () ->
  if not Meteor.user()
    this.render 'login'
  else
    this.next()
    
Router.configure {
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
}

Router.onBeforeAction(requireLogin, {only: ['dashboard']})

Router.route('/', { 
  name: 'home'
  waitOn: () ->
    return [
      Meteor.subscribe('items'),
      Meteor.subscribe('categories'),
      Meteor.subscribe('sites'),
      Meteor.subscribe('subcategories')
    ]

  })

Router.route('/admin', ->
  if Meteor.user()?.username is 'admin'
    this.render 'admin'
  else
    Router.go '/login')

Router.route('/forgotPassword', ->
  this.render 'forgotPassword')

Router.route('/thankyou', ->
  this.render 'thankyou')

Router.route('/contact', ->
  this.render 'contact')

Router.route('/register', ->
  this.render 'register')

Router.route('/login', ->
  this.render  'login')

Router.route('/landing', ->
  this.render  'landing')

Router.route('/dashboard', { 
  name: 'dashboard'
  waitOn: () ->
    return [
      Meteor.subscribe('items'),
      Meteor.subscribe('categories'),
      Meteor.subscribe('sites'),
      Meteor.subscribe('subcategories')
    ]

  })

#### DATA POST ROUTE BELOW ####

Router.route('/datapost', where: 'server')
  .post(->
    item = this.request.body
    if not item.uid? or invalidURL item.url or not Meteor.users.findOne({_id: item.uid})
      return 1

    if item['description[]']?
      item.description = item['description[]']
      delete item['description[]']

    if item['web_taxonomy[]']?
      item.web_taxonomy = item['web_taxonomy[]'] or []
      if typeof item.web_taxonomy is 'string'
        item.web_taxonomy = [item.web_taxonomy]
      delete item['web_taxonomy[]']

    if item.web_taxonomy?.indexOf('Back to search') is not -1
      delete item.web_taxonomy

    item.most_recent_open = parseInt item.open
    item.most_recent_close = parseInt item.close
    delete item.open
    delete item.close

    item.status = 'active'

    if item.web_taxonomy?
      item.category = item.web_taxonomy[0]
      item.filter_name = classify item.category
      item.subcategories = classify(subcat) for subcat in item.web_taxonomy[1..]
    
    console.log "[POST] Request created."
    console.log item

    if not Sites.findOne {name: item.site, uid: item.uid}
      Sites.insert({name: item.site, uid: item.uid})

    id = Items.findOne {name: item.name, site: item.site}
    if id?
      console.log 'Item already in database. Updating.'
      if (isNaN id.total_time_open)
        item.total_time_open = item.most_recent_close - item.most_recent_open
      else
        item.total_time_open = id.total_time_open + item.most_recent_close - item.most_recent_open
      Items.update id, item
    else
      console.log 'New item found. Inserting.'
      item.total_time_open = item.most_recent_close - item.most_recent_open
      id = Items.insert item

      if item.web_taxonomy?

        done = false
        Categories.find({uid: item.uid}).forEach (category) ->
          if not done and category.name is item.category
            Categories.update category, {$push: { items: id }}

            web_taxonomy = item.web_taxonomy[1..]
            for subcat in web_taxonomy
              if not Subcategories.findOne { super_category: item.category, name: subcat, uid: item.uid }
                Subcategories.insert { super_category: item.category, uid: item.uid, name: subcat, filter_name: classify(subcat)}

            done = true

        if not done
          new_category =
            name: item.category
            uid: item.uid
            items: [id]
            filter_name: item.filter_name
          console.log('Creating new category: ' + new_category.name)
          Categories.insert new_category

          web_taxonomy = item.web_taxonomy[1..]
          for subcat in web_taxonomy
            if not Subcategories.findOne { super_category: new_category.name, name: subcat, uid: item.uid }
              Subcategories.insert { super_category: new_category.name, uid: item.uid, name: subcat, filter_name: classify(subcat)}

      else
        # do nothing for now
        
        # # no keywords
        # done = false
        # Categories.find({uid: item.uid}).forEach (category) ->
        #   matched = matchSingleName(item.name, category.name)
        #   if matched and not done
        #     console.log('Matched to category ' + category.name + '.')
        #     console.log(category.keywords)
        #     console.log(item.name)
        #     Items.update id, {$set: {category: category.name, filter_name: classify(category.name)}}
        #     Categories.update category, {$push: {items: id}}
        #     done = true

        # if not done
        #   # this'll be complex...
        #   new_category =
        #     name: item.name
        #     keywords: []
        #     uid: item.uid
        #     items: [id]
        #     filter_name: classify(item.web_taxonomy[Math.max(item.web_taxonomy.length - 2)])
        #   console.log('Creating new category: ' + new_category.name)
        #   Items.update id, {$set: {category: new_category.name, filter_name: classify(new_category.name)}}
        #   Categories.insert new_category

    console.log "[POST] End."
    return 1
    )




