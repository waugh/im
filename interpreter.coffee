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

###

  One of the most fundamental phenomena to lay out is closure.
  Another very fundamental phenomenon to address is the one-shot logical 
  variable.

  The concept of closure is so powerful that it can make all objects.
  Take cons for example. We need cons and snoc. Car and cdr as operations for
  decomposing a cons node assume copyability, but snoc supports linear
  structures.

  \ cons car: car cdr: cdr -> switch!
    case! snoc car_into: carvar cdr_into: cdrvar ->
      carvar := car & cdrvar := cdr

###

make_cons = ->
  cons = Closure.new()
  carname = symbol 'car'
  cdrname = symbol 'cdr'
  carpar = cons.parameter_by_keyword carname
  cdrpar = cons.parameter_by_keyword cdrname
  a_switch = LogicalSwitch.new()
  cons.consequent a_switch
  snoc = a_switch.new_case()
  snoc.verb symbol 'snoc'
  carvar = snoc.parameter_by_keyword symbol 'car_into'
  cdrvar = snoc.parameter_by_keyword symbol 'cdr_into'
  a_conj = LogicalConjunction.new()
  snoc.consequent a_conj
  a_conj.add_conjunct carasg = Assignment.new()
  a_conj.add_conjunct cdrasg = Assignment.new()
  carasg.lhs carvar
  cdrasg.lhs cdrvar
  carasg.rhs carpar
  cdrasg.rhs cdrpar
  cons
exercise_cons = ->
  an_appl = Application.new()
  an_appl.func cons
  an_appl.argument_by_keyword(symbol 'car') literal 2
  an_appl.argument_by_keyword(symbol 'cdr') literal 3
  r = an_appl.result()
  c = r.call()
  c.verb symbol 'snoc'
  c.argument_by_keyword(symbol 'carinto') (car_r = Variable.new()).teller()
  c.argument_by_keyword(symbol 'cdrinto') (cdr_r = Variable.new()).teller()
  car_r.evaluate_using_trampoline trampoline
  cdr_r.evaluate_using_trampoline trampoline
  trampoline.exhaust() # could run forever.
  assert car_r.is_reduced_to_literal(), 'car_r reduced'
  assert cdr_r.is_redduced_to_literal(), 'cdr_r reduced'
  assert.strictEqual 2, car_r.value(), 'car value'
  assert.strictEqual 3, cdr_r.value(), 'cdr value'

# have to implement enough stuff to execute the above examples.

class Parameter

add_new_to_class Parameter

class Closure
  constructor: ->
    @consequent = newvar()
    @parameters_by_keyword = newvar KeyedCollection.new()
    @parameters_by_keyword().factory Parameter
  parameter_by_keyword: (kw) ->
    @parameters_by_keyword().at kw

add_new_to_class Closure

class Case
  constructor: ->
    @verb = newvar()
    @consequent = newvar()
    @parameters_by_keyword = newvar KeyedCollection.new()
    @parameters_by_keyword().factory Parameter
  parameter_by_keyword: (kw) ->
    @parameters_by_keyword().at kw

add_new_to_class Case

class LogicalSwitch
  constructor: ->
    @cases = UnkeyedCollection.new()
    @cases.factory Case
  new_case: ->
    @cases.new()

add_new_to_class LogicalSwitch

class Application

add_new_to_class Application

class LogicalConjunction
  constructor: ->
    @conjuncts = newvar UnkeyedCollection.new()
  add_conjunct: (a_new_conjunct) ->
    @conjuncts().add a_new_conjunct
add_new_to_class LogicalConjunction

class Assignment
  constructor: ->
    @lhs = newvar()
    @rhs = newvar()

add_new_to_class Assignment

exports.Closure = Closure
exports.Application = Application
exports.LogicalSwitch = LogicalSwitch
exports.Parameter = Parameter
exports.Assignment = Assignment
exports.make_cons = make_cons
exports.exercise_cons = exercise_cons

