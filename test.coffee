compiler = require './compiler'

# Procedure definition and procedure application are fundamental to the
# interpreter.
# Have to create a simple example so as to debug those features into existence.
# The first example procedure must have conditional code within it, in order to
# mean much with respect to debugging lazy evaluation into existence. What
# overhead costs will the design exact, per application, for portions of code
# that don't have to run for that application?

example = [ 'procedure',
  params: ['a', 'b', 'r']
  body: [
    ['if', condition: '' ... ]
  ]
]

exports.example = example
