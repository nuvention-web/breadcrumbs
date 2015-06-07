smtp = 
  username: 'no-reply@breadcrumbs.ninja'  
  password: 'brown2town'  
  server:   'smtp.gmail.com' 
  port: 25

process.env.MAIL_URL = 'smtp://' + encodeURIComponent(smtp.username) + ':' + encodeURIComponent(smtp.password) + '@' + encodeURIComponent(smtp.server) + ':' + smtp.port

Accounts.emailTemplates.from = 'no-reply <no-reply@breadcrumbs.ninja>'

Accounts.emailTemplates.siteName = 'breadcrumbs.ninja'

Accounts.emailTemplates.verifyEmail.subject = (user) ->
  return 'Confirm your email address for breadcrumbs/'

Accounts.emailTemplates.verifyEmail.html = (user, url) ->
  return '<h3>Hi online shopper!</h3></br><p>Thank you for signing up. Now you can start using breadcrumbs/ to keep track of your shopping research. Every product you view will be collected by the extension and added to your dashboard.</p></br><h4>Follow this link to verify your email address: </h4><a href = "' + url +'">' + url + '</a><h4>To access your dashboard, please go to: </h4>' + '<a href = "https://breadcrumbs.ninja/dashboard">https://breadcrumbs.ninja/dashboard</a></br><p>If you have any questions, please feel free to contact hi@breadcrumbs.ninja. A team member will respond as soon as possible.</p></br><p>Have fun shopping!</p></br></br><b>Breadcrumbs for Online Shopping <br>Your personal online shopping assistant<br></b>hi@breadcrumbs.ninja | https://breadcrumbs.ninja | https://www.facebook.com/getbreadcrumbs | https://twitter.com/getbreadcrumbs'

# SyncedCron.config
#   log: true
#   logger: null
#   collectionName: 'cronHistory'
#   utc: false
#   collectionTTL: 172800

# SyncedCron.add
#   name: 'Send weekly digest email'
#   schedule: (parser) ->
#     # parser is a later.parse object
#      parser.text 'at 8:07pm on Tuesday'
#   job: ->
#     Meteor.users.find().forEach (user) ->
#       Email.send
#         from: 'no-reply@breadcrumbs.ninja'
#         to: user.emails[0].address
#         subject: 'Meteor Can Send Emails via Gmail'
#         text: 'syndchredchron is doing its job bruh'

# SyncedCron.start()

