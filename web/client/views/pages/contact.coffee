Session.setDefault('contactFormSubmit', false)
Template.contact.events
  'submit form': (event) ->
    event.preventDefault()
    event.stopPropagation()

    name = event.target.name.value
    email = event.target.email.value
    message = event.target.message.value

    if isNotEmpty(email) and isNotEmpty(name) and isNotEmpty(message) and isEmail(email)
    # to, from, subject, msg
        Meteor.call('sendEmail',
                email,
                'hi@breadcrumbs.ninja',
                'Hello from Breadcrumbs/!',
                'Thank you ' + name + ' for your feedback! We will be in touch shortly :) \n\n' + 'Your message: ' + message)
        Meteor.call('sendEmail',
                'hi@breadcrumbs.ninja',
                email,
                'Feedback Receieved. Please Read. From:' +  email,
                'Name: ' + name + '\n Email: ' + email + '\n\n Comments: ' + message)
    Session.set('contactFormSubmit', true)
    Session.set('contactFormEmail', email)
    Router.go '/thankyou'