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

Router.route('/history/:category', ->
  this.render 'history', {
    name: 'history',
    data: {
      category: this.params.category
    }
  }
)

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
    id = RefinedData.findOne {url: view.url, uid: view.uid} # need to increment time spent
    if id?
      console.log 'good'
      RefinedData.update id, {$inc: {count: 1, totalTime: view.totalTime}, $push: {visits: view.visits[0]}, $set: {end: view.end, start: view.start}}
      if id.visits.length > 10
        RefinedData.update id, {$pop: {visits: -1}}
    else
      RefinedData.insert view

    console.log "[POST] End."
    return 1
    )




