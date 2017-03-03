Template.customConsole.onCreated ->
  @open = new ReactiveVar false
  @opacity = new ReactiveVar '0.0'
  @position = new ReactiveVar '-2em'
  @toggle = => if @open.get() then @hide() else @show()
  @show = =>
    #console.log 'showing'
    @open.set true
    @opacity.set '0.6'
    @position.set '0'
    @focus()
  @hide = =>
    #console.log 'hiding'
    @open.set false
    @opacity.set '0.6'
    @position.set '-2em'
    @blur()
  @focus = => @$('input').focus()
  @blur = => @$('input').blur()

  window.customConsole ?= new Console()
  customConsole.ui = @

  $(document).on 'keyup', (event) ->
    if event.which is 220
      event.preventDefault()
      customConsole.ui.toggle()

Template.customConsole.onRendered -> customConsole.linkInput '#cl'

Template.customConsole.helpers
  position: -> Template.instance().position.get()
  opacity: -> Template.instance().opacity.get()

Template.customConsole.events
  "keyup input": (event, instance) -> event.stopPropagation() unless event.which is 220
  "keydown input": (event, instance) ->
    switch event.which
      when 220 #toggle console key
        event.preventDefault() #don't type the key, but trigger the listener
      when 13 #enter key
        event.preventDefault()
        event.stopPropagation()
        command = event.currentTarget.value
        if command is ''
          instance.hide()
        else customConsole.execute command
      when 27 #escape
        event.preventDefault()
        instance.hide()
      when 38 #up
        event.preventDefault()
        event.stopPropagation()
        customConsole.prev()
      when 40 #down
        event.preventDefault()
        event.stopPropagation()
        customConsole.next()
      else #some other key
        event.stopPropagation() #allow normal typing, but stop the event
