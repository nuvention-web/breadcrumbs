requireLogin = () ->
  if not Meteor.user()
    this.render 'login'
  else
    this.next()
    
Router.onBeforeAction(requireLogin, {only: ['dashboard', 'history', 'categories']})

Router.route('/', ->
  this.render 'landing')

Router.route('/admin', ->
  if Meteor.user()?.username is 'admin'
    this.render 'admin'
  else
    Router.go '/login')

# Router.route('/login', ->
#   if Meteor.user()?.username is 'admin'
#     Router.go '/admin'
#   else
#     this.render 'login')

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

Router.route('/dashboard', ->
  this.render 'dashboard', {
    name: 'dashboard',
    })

Router.route('/account/create', ->
  this.render('accountCreate'))

Router.route('/account/categories', ->
  this.render 'categories', {
    name: 'cateogires'
    })

#### DATA POST ROUTE BELOW ####

Router.route('/datapost', where: 'server')
  .post(->
    view = this.request.body
    # parse full domain structure
    domain = ''
    bracketCount = 0

    for ch in view.url
      if domain == 'www.'
        domain = ''

      if ch == '/'
        bracketCount++
      else if bracketCount == 2
        domain += ch
    view.domain = domain
        
    console.log "[POST] Request created."
    console.log view

    id = PageData.findOne {url: view.url}
    if id?
      PageData.update id, {$inc: {counts: 1}}
    else
      view.counts = 1
      PageData.insert view

    view = refineView view

    id2 = RefinedData.findOne {url: view.url}
    if id2?
      RefinedData.update id, {$inc: {counts: 1}}
    else
      view.counts = 1
      RefinedData.insert view

    console.log "[POST] End."
    return 1
    )




