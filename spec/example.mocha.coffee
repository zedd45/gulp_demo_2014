## This is an example of how we can configure tests.  This is not a real 

describe "Example Suite", ->

    # set outside the scope of before, so it's available to describe block
    thumbs = null

    before ->
        # this... strange... syntax is how we attach DOM to our headless window object
        document.body.insertAdjacentHTML( 'beforeend', window.__html__['fixtures/example.html'] )

    after ->
        thumbs = null
  
    describe "Fixture Test", ->
        it "should allow us to load arbitrary HTML and make assertions against it", ->
            thumbs = document.querySelector('.flex-control-thumbs')
            thumbs.innerHTML.should.match /orange/ig
