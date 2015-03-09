Template.navbar.helpers
  category: () ->
    if document.URL.indexOf('/history/') != -1
      split = document.URL.split '/'
      return '/' + unescape(split[split.length-1])
    else
      return ''
  name: () ->
    return Meteor.user().username


Template.navbar.events
  'click #logout': (event) ->
    event.preventDefault()
    event.stopPropagation()

    Meteor.logout()