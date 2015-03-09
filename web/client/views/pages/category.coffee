Template.category.helpers
    headline: () ->
        return RefinedData.findOne {category: this.name, uid: Meteor.userId()}, {sort: {count: -1}}

    # pages: () ->
    #     return RefinedData.find {category: this.name, uid: Meteor.userId()}, {sort: {score: -1}, skip: 1, limit: 5}

requestXDomain = (site, callback) ->
    yql = 'http://query.yahooapis.com/v1/public/yql?q=' + encodeURIComponent('select * from html where url="' + site + '"') + '&format=xml&callback=cbFunc';
    $.getJSON yql, (data)->
        if data.results[0]
            data = data.results[0].replace /<script[^>]*>[\s\S]*?<\/script>/gi, ''

            callback? data
        else
            console.log 'data'
            console.log 'what'

Template.category.rendered = () ->
    # console.log 'hii'
    # requestXDomain 'http://google.com', (data) ->
    #     console.log data