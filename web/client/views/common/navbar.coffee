# // Template.navbar.rendered = function () {
# //     $(window).scroll(function() {
# //         if ($('header').offset().top > 50) {
# //             $('header').addClass('header-active');
# //         } else {
# //             $('header').removeClass('header-active');
# //         }
# //     });
# // };

# Template.navbar.events
    # 'click img': (e) ->
    #     e.preventDefault()
    #     Meteor.call 'refreshDB'