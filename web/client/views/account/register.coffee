Template.register.events
	'click #login': (event) ->
		event.preventDefault()
		Router.go '/login'

Template.register.events 'submit #registerForm': (e, t) ->
  e.preventDefault()
  signUpForm = $(e.currentTarget)
  email = trimInput(signUpForm.find('#email').val().toLowerCase())
  password = signUpForm.find('#password').val()
  passwordConfirm = signUpForm.find('#confirmPassword').val()
  if isNotEmpty(email) and isNotEmpty(password) and isEmail(email) and areValidPasswords(password, passwordConfirm)
    Accounts.createUser {
      email: email
      password: password
    }, (err) ->
      if err
        if err.message == 'Email already exists. [403]'
          console.log 'We are sorry but this email is already used.'
        else
          console.log 'We are sorry but something went wrong.'
          Session.set('currentRegisterEmail', email)
          Router.go '/thankyou'
      else
        console.log 'Congrats new Meteorite, you\'re in!'
        Router.go '/'
      return
  false





@trimInput = (value) ->
  value.replace /^\s*|\s*$/g, ''

@isNotEmpty = (value) ->
  if value and value != ''
    return true
  console.log 'Please fill in all required fields.'
  false

@isEmail = (value) ->
  filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
  if filter.test(value)
    return true
  console.log 'Please enter a valid email address.'
  false

@isValidPassword = (password) ->
  if password.length < 6
    console.log 'Your password should be 6 characters or longer.'
    return false
  true

@areValidPasswords = (password, confirm) ->
  if !isValidPassword(password)
    return false
  if password != confirm
    console.log 'Your two passwords are not equivalent.'
    return false
  true
