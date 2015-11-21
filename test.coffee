compiler = require './compiler'

# Procedure definition and procedure application are fundamental to the
# interpreter.
# Have to create a simple example so as to debug those features into existence.
# There also has to be conditional execution. I have had the insight that a
# conditional command is essentially a procedure definition that is immediately
# applied. I describe it that way on the grounds that it contains code that may
# or may
# not get executed, so it quotes code. So conditional code and procedure
# definitions share the important charcteristic that they quote code. Another
# way to look at a procedure definition is that as it might never get executed,
# it is conditional.

# The first example procedure must have conditional code within it, in order to
# mean much with respect to debugging lazy evaluation into existence. What
# overhead costs will the design exact, per application, for portions of code
# that don't have to run for that application?

id = (x) -> x

ex = ->
  id
    key: 'value'
    other_key: 'other value'

exports.ex = ex
