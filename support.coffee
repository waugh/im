newvar = (init) ->
  # Make a new variable and return it (not an IM variable).
  it = init
  (newval) -> 
    if newval? then it = newval
    it

load = (short_name) -> # Reload a module from its file.
  delete global.require.cache[global.require.resolve short_name]
  global.require short_name

infect_from = (tgt, src) ->
  keys = Object.keys src
  for k in keys
    tgt[k] = src[k]
  keys

my_exports =
  load:             load
  newvar:           newvar

infect = (tgt) -> infect_from tgt, my_exports

exports.infect      = infect
exports.my_exports  = my_exports
exports.infect_from = infect_from
infect exports

console.log 'support.coffee'

