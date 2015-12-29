# This file affects a global variable.

support           = require './support'
newvar            = support.newvar
add_new_to_class  = support.add_new_to_class
UnkeyedCollection = support.UnkeyedCollection
KeyedCollection   = support.KeyedCollection
imperatrix_mundi  = (require './global_variable').the

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

class FiredEventState
  register: (an_action) ->
    trampoline.defer an_action
    true
  fire: ->
    true # do no harm.
  has_tripped: -> true
FiredEventState.the = new FiredEventState()

class UnfiredEventState
  constructor: (spec) ->
    @for_event = spec.for_event
    @registrants = []
    this
  register: (an_action) ->
    @registrants.push an_action
    true
  fire: ->
    for action in @registrants
      trampoline.defer action
    @for_event.state FiredEventState.the
    true
  has_tripped: -> false
UnfiredEventState.new = (spec) -> new UnfiredEventState spec

# Event could be rewritten as a Coffeescript class, straightforwardly.
Event = ( ->
  parent =
    register: (an_action) -> this.state().register an_action,
    fire:                 -> this.state().fire(),
    has_tripped:          -> this.state().has_tripped
  constructor = ->
    spec = {for_event: this}
    init_state = UnfiredEventState.new spec
    this.state = newvar init_state
    this
  constructor.prototype = parent
  constructor.new = -> new constructor
  constructor
)()

exports.Event = Event
exports.UnfiredEventState = UnfiredEventState # for debugging.
