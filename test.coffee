support           = require './support'
newvar            = support.newvar

ex_parent =
  a: -> "a"
ex_constructor = ->
  this.state = newvar(3)
  this
ex_constructor.prototype = ex_parent

exports.ex_parent = ex_parent
exports.ex_constructor = ex_constructor
exports.ex_instance = new ex_constructor
