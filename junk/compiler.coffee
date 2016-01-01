support = require './support'
newvar           = support.newvar
add_new_to_class = support.add_new_to_class

class Symbol
  constructor: ->
    @name = newvar ''
    @belonging_to_symbol_table = newvar undefined

add_new_to_class Symbol

class SymbolTable

  constructor: ->
    @_ = # Use _ for private variables.
      symbols_by_string: {}

  symbol_from_string: (a_string) ->
    hit = @_.symbols_by_string[a_string]
    unless hit?
      hit = Symbol.new()
      hit.name a_string
      hit.belonging_to_symbol_table this
      @_.symbols_by_string[a_string] = hit
    hit

add_new_to_class SymbolTable

# For testing and examples and maybe for real as well, set up a default symbol
# table in the global variable for the project.

infect = (patsy) ->
  dflt = SymbolTable.new()
  patsy.default_symbol_table = dflt
  patsy.symbol = dflt.symbol_from_string.bind dflt
  ['default_symbol_table', 'symbol']

imperatrix_mundi = (require './global_variable').the
imperatrix_mundi.symbol? or infect imperatrix_mundi

exports.SymbolTable = SymbolTable
exports.Symbol      = Symbol
exports.infect      = infect

