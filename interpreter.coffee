support          = require './support'
lazy_init        = support.lazy_init
add_new_to_class = support.add_new_to_class
scheduler        = require './scheduler'
Event            = scheduler.Event

# I didn't want to go this route.

class LogicalVariable
  constructor: ->
    @demand_event           = lazy_init Event.new
    @result_available_event = lazy_init Event.new
add_new_to_class LogicalVariable

module.exports =
  LogicalVariable: LogicalVariable
