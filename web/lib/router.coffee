# requires a login. If user, login template. else skip
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
      Meteor.subscribe('brands')
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

Router.route('/verify', ->
  this.render 'waitVerification')

Router.route('/landing', ->
  this.render  'landing')

Router.route('/team', ->
  this.render  'team')

Router.route('/dashboard', { 
  name: 'dashboard'
  waitOn: () ->
    return [
      Meteor.subscribe('items'),
      Meteor.subscribe('categories'),
      Meteor.subscribe('sites'),
      Meteor.subscribe('subcategories')
      Meteor.subscribe('brands')
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
    item.filter_name = classify item.category

    if item.web_taxonomy?
      item.subcategories = [classify(subcat) for subcat in item.web_taxonomy[1..]][0]

      if item.brand and not Brands.findOne { brand: item.brand, super_category: item.category, uid: item.uid, filter_brand: classify(item.brand) }
        Brands.insert { brand: item.brand, super_category: item.category, uid: item.uid, filter_brand: classify(item.brand) }
    
    if item.brand
      item.filter_brand = classify item.brand

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

      category_id = Categories.findOne {uid: item.uid, name: item.category}
      if not category_id
        Categories.insert {
            name: item.category
            uid: item.uid
            filter_name: classify(item.category)
            count: 1
        }
      else
        Categories.update category_id, {$inc: {count: 1}}

      subcat_id = Subcategories.findOne { super_category: item.category, name: main_subcategory, uid: item.uid }
      if not subcat_id
        main_subcategory = item.web_taxonomy[1]
        Subcategories.insert {
            super_category: item.category
            uid: item.uid
            name: main_subcategory
            filter_name: classify(main_subcategory)
            count: 1
        }
      else
        Subcategories.update subcat_id, {$inc: {count: 1}}

    console.log "[POST] End."
    return 1
    )




