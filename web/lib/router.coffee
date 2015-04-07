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

    item.most_recent_open = item.open
    item.most_recent_close = item.close
    delete item.open
    delete item.close
        
    console.log "[POST] Request created."
    console.log item

    id = Items.findOne {main_image: item.main_image}
    if id?
      console.log 'Item already in database. Updating.'
      item.total_time_open = id.total_time_open + item.close - item.open
      Items.update id, item
    else
      console.log 'New item found. Inserting.'
      item.total_time_open = item.close - item.open
      Items.insert item

    console.log "[POST] End."
    return 1
    )




