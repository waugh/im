# Includes support for programming and support for loading module files.

# Support for programming.

# Make a new variable and return it (not an IM variable).
newvar = (init) ->
  it = init
  (args...) -> 
    if args.length > 0 then it = args[0]
    it

# What about lazy initialization / memoization ?
lazy_init = (init) ->
  beh = ->
    value = init()
    beh = -> value
    value
  -> beh()

# Add a .new method to a Coffee class or to any constructor function.
add_new_to_class = (a_class) ->
  a_class.new = (args...) -> new a_class args...

# Wrappers around basic Javascript types.

class UnkeyedCollection
  constructor: ->
    @underlying = newvar []
    @factory = newvar()
  add: (new_elt) ->
    @underlying().push new_elt
    true
  new: ->
    n = @factory().new()
    @add n
    n
  map: (f) ->
    f elt for elt in @underlying()
add_new_to_class UnkeyedCollection

class KeyedCollection
  constructor: ->
    @underlying = newvar {}
    @factory = newvar()
  at: (key) ->
    hit = @underlying()[key]
    unless hit?
      hit = @factory().new()    # Am I sure it should work this way??
      @underlying()[key] = hit
    hit
add_new_to_class KeyedCollection

# Support for reloading module files after they have been changed.

load = (short_name) ->
  delete global.require.cache[global.require.resolve short_name]
  global.require short_name


module.exports =
  load: load
  add_new_to_class: add_new_to_class
  newvar: newvar
  UnkeyedCollection: UnkeyedCollection
  KeyedCollection:  KeyedCollection
  lazy_init: lazy_init

