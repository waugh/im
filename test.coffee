support           = require './support'

lazy_init = support.lazy_init
ex = lazy_init ->
  console.log "called"
  5
exports.ex = ex
