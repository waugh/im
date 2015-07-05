# Includes support for programming and support for loading module files.

# Support for programming.

# Make a new variable and return it (not an IM variable).
newvar = (init) ->
  it = init
  (newval) -> 
    if newval? then it = newval
    it

# Add a .new method to a Coffee class or to any constructor function.
add_new_to_class = (a_class) ->
  a_class.new = (args...) -> new a_class args...


# Support for reloading module files after they have been changed.

load = (short_name) ->
  delete global.require.cache[global.require.resolve short_name]
  global.require short_name


# Wrap it all up.

exports.load             = load
exports.add_new_to_class = add_new_to_class
exports.newvar           = newvar


###
Code that is not in use and may be on its way to being trashed.

infect_from = (tgt, src) ->
  keys = Object.keys src
  for k in keys
    tgt[k] = src[k]
  keys
###
