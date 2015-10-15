support = require './support'
newvar           = support.newvar
add_new_to_class = support.add_new_to_class
UnkeyedCollection = support.UnkeyedCollection
KeyedCollection = support.KeyedCollection
imperatrix_mundi = (require './global_variable').the
compiler = require './compiler'
symbol = imperatrix_mundi.symbol # Placed there by compiler.
assert symbol?

class Trampoline
  # An instance can remember (in volatile memory) steps that are ready to be
  # performed in order to advance the interpretation.
  constructor: ->
    @_ = # private variables.
      ready_tasks: []
  is_idle: ->
    @_.ready_tasks.length is 0
  step: -> # Carry out a step if any are ready; otherwise do no harm.
    len = @_.ready_tasks.length
    if len > 0
      @_.ready_tasks.shift()(this)
    len
  defer: (a_task) -> # Remember something to do.
    @_.ready_tasks.push a_task
    @_.ready_tasks.length
  exhaust: ->
    @step() until @is_idle()
    true
add_new_to_class Trampoline

imperatrix_mundi.trampoline? or imperatrix_mundi.trampoline = new Trampoline()
trampoline = imperatrix_mundi.trampoline

class Terminal
  constructor: ->
    @partner = newvar()
  send_demand: ->
    tgt = partner()
    trampoline.defer -> tgt.receive_demand()
  send_literal: (value) ->
    tgt = partner()
    trampoline.defer -> tgt.receive_literal value
  connect_with: (new_partner) ->
    @partner new_partner
    new_partner.partner this

( ->
)()
