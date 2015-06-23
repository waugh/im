JackClass = ( ->
  ###
    Unfinished
  ###
  r = (cmd, args...) ->
    ['args'].concat args
  r
)()

load = (short_name) ->
  delete global.require.cache[global.require.resolve short_name]
  global.require short_name

exports.module    = module
exports.load      = load

console.log 'misc.coffee'
