###
  into: bar -> bar := 2
###

ns = new CompileTimeRuntimeNamespace()
ex1 = source.new_procedure()
into = ex1.add_parameter()
into.keyword = source.symbol 'into'
two = source.literal 2
into.gets two



console.log 'source.coffee'
