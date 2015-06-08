# Meteor.call methods
Meteor.methods
  
    deactivateCategory: (category, uid) ->
      Categories.remove category
      Subcategories.remove { super_category: category.name, uid: uid }
      Items.remove { category: category.name }

    makeUser: (user) ->
        Accounts.createUser user

    pingTest: (data) ->
        console.log '[PING]'
        console.log data
        return '[PONG]'

    sendEmail: (to, from, subject, text) ->
      process.env.MAIL_URL = 'smtp://hi%40breadcrumbs.ninja:brown2town@smtp.gmail.com:465/'
      console.log 'contact e-mail sent!'
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

    getUserId: (email) ->
      return Meteor.users.findOne({'emails.address' : email})

    sendVerificationEmail: (user,email) ->
      process.env.MAIL_URL = 'smtp://no-reply%40breadcrumbs.ninja:brown2town@smtp.gmail.com:465/' 
      if user == null
        user = Meteor.call('getUserId', email)
      Meteor.setTimeout (->
        Accounts.sendVerificationEmail user._id
        console.log 'verification email sent'
        return
      ), 2 * 750
      user
    # sendAllUsersEmail: (to, from, subject, text) ->
      

