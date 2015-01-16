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


