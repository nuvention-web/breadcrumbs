smtp = 
  username: 'no-reply@breadcrumbs.ninja'  
  password: 'brown2town'  
  server:   'smtp.gmail.com' 
  port: 25

process.env.MAIL_URL = 'smtp://' + encodeURIComponent(smtp.username) + ':' + encodeURIComponent(smtp.password) + '@' + encodeURIComponent(smtp.server) + ':' + smtp.port

Accounts.emailTemplates.from = 'breadcrumbs/ <no-reply@breadcrumbs.ninja>'

Accounts.emailTemplates.siteName = 'breadcrumbs/ ninja'

Accounts.emailTemplates.verifyEmail.subject = (user) ->
  return 'breadcrumbs/ Confirm Your Email Address'

Accounts.emailTemplates.verifyEmail.text = (user, url) ->
  return 'click on the following link to verify your email address: \n' + url

