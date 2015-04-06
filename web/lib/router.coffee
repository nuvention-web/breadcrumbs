requireLogin = () ->
  # if not Meteor.user()
  #   this.render 'login'
  # else
  #   this.next()
  this.next()
    
Router.configure {
  layoutTemplate: 'layout'
}

Router.onBeforeAction(requireLogin, {only: ['dashboard', 'history', 'categories']})

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

    site = ''
    bracket_count = 0
    for ch in item.url
      if site == 'www.'
        site = ''

      if ch == '/'
        bracket_count++
      else if bracket_count == 2
        site += ch
    item.site = site
        
    console.log "[POST] Request created."
    console.log item

    id = Items.findOne {main_image: item.main_image}
    if id?
      console.log 'Item already in database. Updating.'
      Items.update id {
        $inc: {total_time_open: item.close - item.open},
        $set: {
          most_recent_open: item.open,
          most_recent_close: item.close,
          price: item.price,
          url: item.url,
          rating: item.rating,
          description: item.description,
        }
      }
    else
      item.most_recent_open = item.open
      item.most_recent_close = item.close
      item.total_time_open = item.close - item.open
      delete item.open
      delete item.close
      Items.insert item

    console.log "[POST] End."
    return 1
    )




