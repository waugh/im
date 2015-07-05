imperatrix_mundi? or imperatrix_mundi = {}

class Trampoline
  # An instance can remember (in volatile memory) steps that are ready to be
  # performed in order to advance the interpretation.
  constructor: ->
    @_v =
      ready_tasks: []
  is_idle: ->
    @_v.ready_tasks.length is 0
  step: -> # Carry out a step if any are ready.
    len = @_v.ready_tasks.length
    if len > 0
      @_v.ready_tasks.shift()(this)
    len
  defer: (a_task) -> # Remember something to do.
    @_v.ready_tasks.push a_task
    @_v.ready_tasks.length

imperatrix_mundi.trampoline = new Trampoline()
trampoline = imperatrix_mundi.trampoline

###

  Maybe there should be two distinct graph structures -- one to transmit demand
  for values and notification of the results, and a second graph structure to
  handle the arguments going in the direction of elaboration of the program.
  Demand can go in either direction relative to the elaboration graph.

  One of the most fundamental phenomena to lay out is closure.
  Another very fundamental phenomenon to address is the one-shot logical 
  variable. How closure and logical variables fit in one another may get
  quite interesting.

  The concept of closure is so powerful that it can make all objects.
  Take cons for example. We need cons and snoc. Car and cdr as operations for
  decomposig a cons node assume copyability, but snoc supports linear
  structures.

  \ cons car: car cdr: cdr -> switch!
    case! snoc car_into: carvar cdr_into: cdrvar ->
      carvar := car & cdrvar := cdr

###


my_exports =
  imperatrix_mundi: imperatrix_mundi

infect = (tgt) ->
  keys = Object.keys my_exports
  for k in keys
    tgt[k] = my_exports[k]
  keys

exports.infect     = infect
exports.my_exports = my_exports

console.log 'interpreter.coffee'

