# Regression testing.

scheduling = require './scheduling'
Event      = scheduling.Event
trampoline = imperatrix_mundi.trampoline # a global set by schedule.
laziness   = require './lazy'
strict_func_to_lazy        = laziness.strict_func_to_lazy
logical_variable_for_value = laziness.logical_variable_for_value
LogicalVariable            = laziness.LogicalVariable

failure_count = 0
assert = (passed) ->
  if passed
    console.log "... passed."
  else
    console.log "... Failed! WTF??"
    failure_count += 1
  console.log ""

console.log "Testing events:"
console.log ""
console.log "Conjunction over no events should fire immediately."
passed = false
Event.conjunction_over([]).register -> passed = true
trampoline.exhaust()
assert passed

console.log "An event conjunction involving an event that has not been fired,"
console.log "should not fire as a whole."
fired = false
a = Event.new()
b = Event.new()
b.fire()
Event.conjunction_over([a, b]).register -> fired = true
trampoline.exhaust()
assert not fired
console.log "But when the inputs have been fired, the conjunction should fire."
a.fire()
trampoline.exhaust()
assert fired

console.log ""
console.log "Testing lazy evaluation:"
console.log ""
in1 = logical_variable_for_value 1
in2 = in1
ins = [in1, in2]
out = LogicalVariable.new()
strictfunc = (a, b) -> a + b
spec =
  result: out
  strict_func: strictfunc
  inputs: ins
strict_func_to_lazy spec
console.log "A lazy operation generally should not happen until the result is"
console.log "is demanded."
trampoline.exhaust()
assert not out.result_available().has_tripped()
out.demand().fire()
trampoline.exhaust()
console.log "An operation whose inputs are available should proceed once there"
console.log "is demand for its result."
assert out.result_available().has_tripped()
console.log "One plus one should evaluate to two."
assert 2 is out.value

module.exports = failure_count
