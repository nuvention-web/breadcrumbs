Template.download.events
    'submit form': (e) ->
        e.preventDefault()

        username = e.target.username.value
        pw = e.target.password.value
        check = e.target.confirmPassword.value

        if pw is not check
            alert "Passwords don't match!"
        # else if Meteor.users.findOne {username: username}
        #     alert "Username already taken!"
        else
            user =
                username: username
                password: pw

            Meteor.call 'makeUser', user, (err, result)->
                if err
                    alert err
                else
                    alert "User account successfully created!"


        