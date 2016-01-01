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


# Support for reloading module files after they have been changed.

load = (short_name) ->
  delete global.require.cache[global.require.resolve short_name]
  global.require short_name


module.exports =
  load:             load
  add_new_to_class: add_new_to_class
  newvar:           newvar
  lazy_init:        lazy_init

