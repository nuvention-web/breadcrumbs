Router.route('/', ->
  this.render 'landing')

Router.route('/admin', ->
  if Meteor.user()?.username is 'admin'
    this.render 'admin'
  else
    Router.go '/login')

Router.route('/login', ->
  if Meteor.user()?.username is 'admin'
    Router.go '/admin'
  else
    this.render 'login')

Router.route('/thanks', ->
  this.render 'thanks')

Router.route('/history', ->
  this.render 'history')

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
    console.log "[POST] End."

    id = PageData.findOne {url: view.url}
    if id?
      PageData.update id, {$inc: {counts: 1}}
    else
      view.counts = 1
      PageData.insert view

    return 1
    )