MochaWeb?.testOnly ->
  describe 'Landing Page', ->
    describe 'Form', ->
      it 'should properly insert elements into the form', (done)->
        setTimeout (->
          $('input[name=fullname]').val 'Kevin Chen'
          $('input[name=email').val 'kevinchen2016@u.northwestern.edu'
          $('input[type=submit').click()

          chai.assert.isNotNull Interest.findOne({email: 'kevinchen2016@u.northwestern.edu'}), 'Element was not inserted.'
          done()
          ), 100

      it 'should not accept duplicate emails', (done)->
        setTimeout (->
          $('input[name=fullname]').val 'Kevin Chen'
          $('input[name=email').val 'kevinchen2016@u.northwestern.edu'
          $('input[type=submit').click()

          $('input[name=fullname]').val 'Kevin Chen'
          $('input[name=email').val 'kevinchen2016@u.northwestern.edu'
          $('input[type=submit').click()

          chai.assert.notEqual $('#messages').css('display'), 'none' 
          done()
          ), 100


  describe 'Restful Data Post', ->
    it 'should properly post data into a database', (done)->
      id = post 'localhost', {name: 'tester_user', email: 'testemail@example.com'}
      chai.assert.isNotNull PageData.findOne(id), 'Data was not inserted.'
      done()



post = (path, params) ->
  method = 'post'

  form = document.createElement 'form'
  form.setAttribute 'method', method
  form.setAttribute 'action', path

  for key in params 
    if params.hasOwnProperty key 
      hiddenField = document.createElement 'input'
      hiddenField.setAttribute 'type', 'hidden'
      hiddenField.setAttribute 'name', key
      hiddenField.setAttribute 'value', params[key]

      form.appendChild hiddenField

  document.body.appendChild form
  form.submit()