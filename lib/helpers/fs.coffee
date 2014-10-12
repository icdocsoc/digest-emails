fs = require('fs')
Q = require('q')

class FS

  @load: (methods...) ->
    for method in methods
      FS[method] ?= Q.nbind(fs[method], fs)
    { FS }

FS.load.FS = FS
module.exports = FS.load
