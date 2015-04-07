requireLogin = () ->
  # if not Meteor.user()
  #   this.render 'login'
  # else
  #   this.next()
  this.next()
    
Router.configure {
  layoutTemplate: 'layout'
}

# Router.onBeforeAction(requireLogin, {only: ['dashboard', 'history', 'categories']})

Router.route('/', { name: 'dashboard'} )

Router.route('/admin', ->
  if Meteor.user()?.username is 'admin'
    this.render 'admin'
  else
    Router.go '/login')

Router.route('/thanks', ->
  this.render 'thanks')

Router.route('/history/:id', {name: 'history'} )

Router.route('/download', ->
  this.render 'download')

# Router.route('/dashboard', ->
#   this.render 'dashboard', {
#     name: 'dashboard',
#     })

Router.route('/account/create', ->
  this.render('accountCreate'))

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
      item.web_taxonomy = item['web_taxonomy[]']
      delete item['web_taxonomy[]']

    item.most_recent_open = parseInt item.open
    item.most_recent_close = parseInt item.close
    delete item.open
    delete item.close
        
    console.log "[POST] Request created."
    console.log item

    id = Items.findOne {main_image: item.main_image}
    if id?
      console.log 'Item already in database. Updating.'
      if (isNaN id.total_time_open)
        item.total_time_open = item.most_recent_close - item.most_recent_open
      else
        item.total_time_open = id.total_time_open + item.most_recent_close - item.most_recent_open
      Items.update id, item
      id = id._id
    else
      console.log 'New item found. Inserting.'
      item.total_time_open = item.close - item.open
      id = Items.insert item

    # id is now the relevant id in the databse
    done = false # use every() instead fo this...
    Categories.find({uid: uid}).forEach (category) ->
      [sufficient, not_matched] = matchKeywords(item.web_taxonomy, category.keywords)
      if sufficient and not done
        Categories.update category, {$push: {
                                      keywords: {$each: not_matched},
                                      items: id}}
        done = true

    if not done
      new_category =
        name: item.web_taxonomy[item.web_taxonomy.length - 1]
        keywords: item.web_taxonomy
        uid: uid
        items: [id]

    console.log "[POST] End."
    return 1
    )




