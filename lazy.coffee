# Lazy evaluation.

support          = require './support'
lazy_init        = support.lazy_init
add_new_to_class = support.add_new_to_class
scheduler        = require './scheduler'
Event            = scheduler.Event

# I didn't want to go this route.

class LogicalVariable
  constructor: ->
    @demand           = lazy_init Event.new
    @result_available = lazy_init Event.new
add_new_to_class LogicalVariable

strict_to_lazy = (spec) ->
  # Given a function that is strict in its arguments, evaluate it lazily.
  result = spec.result
  prim   = spec.prim
  inputs = spec.inputs
  result.demand().register ->
    each.demand().fire() for each in inputs
    ready = Event.conjunction_over(each.result_available() for each in inputs)
    ready.register ->
      result.value = prim((each.value for each in inputs)...)
      result.result_available().fire()
      true
    true
  true

module.exports =
  LogicalVariable: LogicalVariable
