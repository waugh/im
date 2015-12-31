support           = require './support'
scheduler         = require './scheduler'
Event             = scheduler.Event
trampoline = imperatrix_mundi.trampoline # a global set by scheduler.

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

module.exports = failure_count
