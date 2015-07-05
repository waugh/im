# I believe that as a rule, having a lot of global  variables  and  having  them
# referred to from all over the place brings dangers from a software-engineering
# perspective.  However, let's have a global variable for convenience in running
# tests and examples at least. Whether the main working interpreter and compiler
# will refer to it remains unsettled at the time of this writing.

global.imperatrix_mundi? or global.imperatrix_mundi = {}

exports.the = global.imperatrix_mundi
