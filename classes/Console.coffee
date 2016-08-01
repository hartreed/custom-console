root = exports ? this

class Group
  constructor: (@name, @commands = {}) ->
  command: (name, hook) -> @commands[name] = hook
  execute: (name, args) ->
    command = @commands[name]
    if command?
      command args
    else if @commands.default?
      @commands.default args
    else console.log "group #{@name} does not have a command named #{name}"

root.Console = class Console
  history: []
  cursor: 0
  groups: {}
  constructor: ->
    @linkInput()
    @main = new Group('main')

  linkInput: (element = '#cl') -> @input = $(element)

  update: ->
    @input.val @history[@cursor]
    #console.log @cursor

  clear: -> @input.val ''

  command: (name, hook) ->
    @main.command name, hook
    return @ #chain

  addGroup: (name, commands) ->
    @groups[name] = new Group name, commands
    return @ #chain

  group: (name) ->
    group = @groups[name]
    if group? then return group else return null

  setMessage: (message) -> @input.val message

  prev: ->
    if @history.length > @cursor + 1
      val = @input.val()
      if @cursor is -1 and @history[0] isnt val and val isnt ''
        @history.unshift @input.value
        @update()
      else
        @cursor++
        @update()

  next: ->
    if @cursor > 0
      @cursor--
      @update()
    else if @cursor is 0
      @cursor = -1
      @clear()

  execute: (command) ->
    @history.unshift command if @history[0] isnt command
    console.log "command entered: #{command}"
    @clear()
    @cursor = -1
    @parse command

  parse: (command) ->
    commands = command.split(', ')
    for command in commands
      #console.log command
      [command, args...] = command.split(' ')
      group = @group command
      if group?
        subcommand = args.shift()
        group.execute subcommand, args
      else
        @main.execute command, args
