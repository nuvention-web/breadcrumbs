

# smtp = 
#     username: 'no-reply@breadcrumbs.ninja'  
#     password: 'brown2town'  
#     server:   'smtp.gmail.com' 
#     port: 25
  
# process.env.MAIL_URL = 'smtp://' + encodeURIComponent(smtp.username) + ':' + encodeURIComponent(smtp.password) + '@' + encodeURIComponent(smtp.server) + ':' + smtp.port;


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