# Lazy evaluation.

support          = require './support'
lazy_init        = support.lazy_init
add_new_to_class = support.add_new_to_class
scheduling       = require './scheduling'
Event            = scheduling.Event

# I didn't want to go this route.

class LogicalVariable
  constructor: ->
    @demand           = lazy_init Event.new
    @result_available = lazy_init Event.new
add_new_to_class LogicalVariable


# Given a function that is strict in its arguments, insert it in a network
# for lazy evaluation.

strict_func_to_lazy = (spec) ->
  result = spec.result
  prim   = spec.strict_func
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


# Given a determined argument (howsoever some other layer might structure those),
# inject it into the network for lazy evaluation.

logical_variable_for_value = (a_value) ->
  r = LogicalVariable.new()
  r.value = a_value
  r.result_available().fire()
  r

module.exports =
  LogicalVariable:            LogicalVariable
  strict_func_to_lazy:        strict_func_to_lazy
  logical_variable_for_value: logical_variable_for_value
