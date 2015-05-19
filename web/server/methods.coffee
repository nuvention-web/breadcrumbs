Meteor.methods
    makeUser: (user) ->
        Accounts.createUser user

    pingTest: (data) ->
        console.log '[PING]'
        console.log data
        return '[PONG]'

    sendEmail: (to, from, subject, text) ->
      process.env.MAIL_URL = 'smtp://hi%40breadcrumbs.ninja:brown2town2@smtp.gmail.com:465/'
      console.log 'sendEmail'
      check [
        to
        from
        subject
        text
      ], [ String ]
      # Let other method calls from the same client start running,
      # without waiting for the email sending to complete.
      @unblock()
      Email.send
        to: to
        from: from
        subject: subject
        text: text
      return

