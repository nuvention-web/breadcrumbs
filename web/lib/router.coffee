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

Router.route('/datapost', where: 'server')
  .post(->
    console.log '[POST]' + this.request.body
    PageData.insert(this.request.body)
    )